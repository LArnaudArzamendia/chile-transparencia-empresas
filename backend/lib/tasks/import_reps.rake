require "csv"

namespace :reps do
  desc "Importa representantes y roles desde un CSV (ej. Diario Oficial / Sociefy).
        Uso: bin/rails reps:import FILE=/ruta/al/archivo.csv [COL_SEP=';']"
  task import: :environment do
    file = ENV["FILE"]
    col_sep = ENV["COL_SEP"] || ";"

    if file.blank?
      abort "Debes indicar FILE=/ruta/al/archivo.csv"
    end

    unless File.exist?(file)
      abort "No se encontró el archivo: #{file}"
    end

    puts "Importando representantes desde: #{file}"
    puts "Separador de columnas: '#{col_sep}'"

    total = 0
    created_reps = 0
    updated_reps = 0
    created_links = 0
    skipped = 0
    missing_company = 0

    # Helper para obtener valor según posibles nombres de columna.
    def value_for(row, *possible_headers)
      possible_headers.each do |h|
        return row[h] if h && row.headers.include?(h)
      end
      nil
    end

    CSV.foreach(file, headers: true, col_sep: col_sep, encoding: "UTF-8") do |row|
      total += 1

      raw_company_rut = value_for(row, "RUT_EMPRESA", "Rut Empresa", "RUT_SOCIEDAD", "RUT Sociedad", "RUT Sociedad")
      raw_rep_rut     = value_for(row, "RUT_REPRESENTANTE", "Rut Representante", "RUT_REP", "RUT Representante Legal")
      full_name       = value_for(row, "NOMBRE_REPRESENTANTE", "Nombre Representante", "NOMBRE_REP", "Nombre Representante Legal")
      role            = value_for(row, "ROL", "Rol", "CARGO", "Cargo")

      if raw_company_rut.blank? || raw_rep_rut.blank? || full_name.blank?
        skipped += 1
        next
      end

      normalized_company_rut = Company.normalize_rut(raw_company_rut)
      normalized_rep_rut     = Representative.normalize_rut(raw_rep_rut)

      if normalized_company_rut.nil? || normalized_rep_rut.nil?
        skipped += 1
        next
      end

      company = Company.find_by(normalized_rut: normalized_company_rut)
      unless company
        missing_company += 1
        next
      end

      representative = Representative.find_or_initialize_by(normalized_rut: normalized_rep_rut)

      # Guardar info del representante.
      representative.rut ||= raw_rep_rut
      # Normalizar un poco el nombre para que no quede todo en mayúsculas feitas.
      cleaned_name = full_name.strip
      representative.full_name = cleaned_name if representative.full_name.blank? || representative.full_name != cleaned_name

      if representative.new_record?
        if representative.save
          created_reps += 1
        else
          skipped += 1
          next
        end
      else
        if representative.changed?
          if representative.save
            updated_reps += 1
          else
            skipped += 1
            next
          end
        end
      end

      # Crear/actualizar vínculo con rol.
      link = CompanyRepresentative.find_or_initialize_by(
        company: company,
        representative: representative
      )

      # Actualizar rol si viene.
      link.role = role if role.present?

      if link.new_record?
        if link.save
          created_links += 1
        else
          skipped += 1
        end
      else
        link.save if link.changed?
      end

      puts "Procesadas #{total} filas..." if (total % 1000).zero?
    rescue => e
      skipped += 1
      Rails.logger.error "Error en fila #{total}: #{e.class} - #{e.message}"
    end

    puts "Importación terminada."
    puts "Total filas:        #{total}"
    puts "Reps creados:       #{created_reps}"
    puts "Reps actualizados:  #{updated_reps}"
    puts "Vínculos creados:   #{created_links}"
    puts "Sin empresa (skip): #{missing_company}"
    puts "Saltados (otros):   #{skipped}"
  end
end
