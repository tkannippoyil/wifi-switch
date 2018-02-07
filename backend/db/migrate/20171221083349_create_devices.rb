class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.boolean :status, default: false
      t.boolean :connected, default: false
      t.boolean :processing, default: false
      t.string :address
      t.string :ip

      t.timestamps
    end
  end
end
