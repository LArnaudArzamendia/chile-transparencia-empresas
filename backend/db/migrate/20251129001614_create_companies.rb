class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :rut
      t.string :name

      t.timestamps
    end
    add_index :companies, :rut
    add_index :companies, :name
  end
end
