class AddFieldsToCompanies < ActiveRecord::Migration[7.2]
  def change
    add_column :companies, :year, :integer
    add_column :companies, :month, :integer
    add_column :companies, :capital, :decimal, precision: 15, scale: 2
    add_column :companies, :comuna_tributaria, :string
    add_column :companies, :region_tributaria, :string
    add_column :companies, :comuna_social, :string
    add_column :companies, :region_social, :string
    add_column :companies, :company_type, :string
  end
end
