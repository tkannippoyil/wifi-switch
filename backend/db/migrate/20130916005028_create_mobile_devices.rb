class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.string :vendor_registration_id
      t.string :platform
      t.references :user

      t.timestamps
    end
    add_index :mobile_devices, :user_id
  end
end
