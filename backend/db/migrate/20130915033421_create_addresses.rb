class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :suburb
      t.string :postcode
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
