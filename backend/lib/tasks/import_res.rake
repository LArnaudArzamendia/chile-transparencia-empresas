require "csv"

# bin/rails res:import_companies FILE=/mnt/c/Users/Usuario/Downloads/2024-sociedades-por-fecha-rut-constitucion.csv COL_SEP=';'
# Comando para importar empresas desde un CSV del Registro de Empresas y Sociedades (RES).

namespace :res do
  desc "Importa empresas desde un CSV del Registro de Empresas y Sociedades (RES).
        Uso: bin/rails res:import_companies FILE=/ruta/al/archivo.csv [COL_SEP=';']"
  task import_companies: :environment do
    file = ENV["FILE"]
    col_sep = ENV["COL_SEP"] || ";"

    if file.blank?
      abort "Debes indicar FILE=/ruta/al/archivo.csv"
    end

    unless File.exist?(file)
      abort "No se encontró el archivo: #{file}"
    end

    puts "Importando empresas desde: #{file}"
    puts "Separador de columnas: '#{col_sep}'"

    total = 0
    created = 0
    updated = 0
    skipped = 0

    CSV.foreach(file, headers: true, col_sep: col_sep, encoding: "UTF-8") do |row|
      total += 1

      # Columnas del CSV "2024-sociedades-por-fecha-rut-constitucion.csv".
      # ["ID", "RUT", "Razon Social", "Fecha de actuacion (1era firma)", "Fecha de registro (ultima firma)", "Fecha de aprobacion x SII", "Anio", "Mes", "Comuna Tributaria", "Region Tributaria", "Codigo de sociedad", "Tipo de actuacion", "Capital", "Comuna Social", "Region Social"]
      raw_rut          = row["RUT"]
      name             = row["Razon Social"]
      year             = row["Anio"]
      month            = row["Mes"]
      capital          = row["Capital"]
      comuna_trib      = row["Comuna Tributaria"]
      region_trib      = row["Region Tributaria"]
      comuna_social    = row["Comuna Social"]
      region_social    = row["Region Social"]
      company_type     = row["Codigo de sociedad"]

      if raw_rut.blank? || name.blank?
        skipped += 1
        next
      end

      normalized = Company.normalize_rut(raw_rut)
      if normalized.nil?
        skipped += 1
        next
      end

      company = Company.find_or_initialize_by(normalized_rut: normalized)

      # Guardar el rut tal como viene, si no había uno ya.
      company.rut ||= raw_rut

      # Actualizar nombre si está vacío o cambió.
      company.name = name if company.name.blank? || company.name != name

      # Asignar campos extra si vienen en el CSV.
      company.year = year.to_i if year.present?
      company.month = month.to_i if month.present?

      if capital.present?
        # Capital viene como string, ej: "1000000"
        # to_d requiere 'bigdecimal/util', pero ActiveRecord castea string a decimal
        company.capital = capital
      end

      company.comuna_tributaria = comuna_trib if comuna_trib.present?
      company.region_tributaria = region_trib if region_trib.present?
      company.comuna_social = comuna_social if comuna_social.present?
      company.region_social = region_social if region_social.present?
      company.company_type = company_type if company_type.present?

      if company.new_record?
        if company.save
          created += 1
        else
          skipped += 1
        end
      else
        if company.changed?
          if company.save
            updated += 1
          else
            skipped += 1
          end
        end
      end

      puts "Procesadas #{total} filas..." if (total % 1000).zero?
    rescue => e
      skipped += 1
      Rails.logger.error "Error en fila #{total}: #{e.class} - #{e.message}"
    end

    puts "Importación terminada."
    puts "Total filas:   #{total}"
    puts "Creadas:       #{created}"
    puts "Actualizadas:  #{updated}"
    puts "Saltadas:      #{skipped}"
  end
end