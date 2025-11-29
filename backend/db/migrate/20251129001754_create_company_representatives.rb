class CreateCompanyRepresentatives < ActiveRecord::Migration[7.2]
  def change
    create_table :company_representatives do |t|
      t.references :company, null: false, foreign_key: true
      t.references :representative, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
