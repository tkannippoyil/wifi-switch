class CreateNotificationMetadata < ActiveRecord::Migration
  def change
    create_table :notification_metadata do |t|
      t.string :subject
      t.string :message
      t.json :data

      t.timestamps
    end
  end
end
