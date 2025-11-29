class AddNormalizedRutToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_column :companies, :normalized_rut, :string
  end
end
