class CreateRepresentatives < ActiveRecord::Migration[7.2]
  def change
    create_table :representatives do |t|
      t.string :rut
      t.string :full_name

      t.timestamps
    end
    add_index :representatives, :rut
    add_index :representatives, :full_name
  end
end
