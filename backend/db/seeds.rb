# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Limpiar
CompanyRepresentative.delete_all
Representative.delete_all
Company.delete_all

# Empresas
c1 = Company.create!(rut: "76.123.456-7", name: "Constructora Andes SpA")
c2 = Company.create!(rut: "78.987.654-3", name: "Servicios Médicos Pacífico Ltda")
c3 = Company.create!(rut: "77.555.111-9", name: "Tecnologías del Sur S.A.")

# Representantes
r1 = Representative.create!(rut: "12.345.678-9", full_name: "Juan Pérez López")
r2 = Representative.create!(rut: "16.789.234-5", full_name: "María González Silva")
r3 = Representative.create!(rut: "9.876.543-2", full_name: "Luciano Arnaud")

# Relaciones
CompanyRepresentative.create!(company: c1, representative: r1, role: "Representante legal")
CompanyRepresentative.create!(company: c1, representative: r2, role: "Socio")
CompanyRepresentative.create!(company: c2, representative: r2, role: "Representante legal")
CompanyRepresentative.create!(company: c3, representative: r3, role: "Representante legal")

puts "Seeds OK"
