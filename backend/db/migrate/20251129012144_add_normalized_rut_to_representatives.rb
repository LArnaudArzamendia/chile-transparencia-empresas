class AddNormalizedRutToRepresentatives < ActiveRecord::Migration[7.2]
  def change
    add_column :representatives, :normalized_rut, :string
  end
end
