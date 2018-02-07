class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :address

      t.string :name, null: false
      t.string :timezone

      t.float :latitude
      t.float :longitude

      t.boolean  :archived, default: false

      t.timestamps
    end
  end
end
