class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :favorite, null: false,  defualt: false

      t.timestamps
    end
  end
end
