class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, null: false
      t.references :notification_metadata, index: true, null: false
      t.boolean :seen, null: false, default: false

      t.timestamps
    end
  end
end
