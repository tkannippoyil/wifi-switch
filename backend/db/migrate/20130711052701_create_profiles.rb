class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :first_name, null: false
      t.string :last_name
      t.string :salutation
      t.string :gender, default: 'Unspecified'

      t.boolean :archived, default: false
      t.boolean :onboarded, default: false

      t.datetime :last_active
      t.date :date_of_birth

      t.references :user, null: false
      t.references :address

      t.add_attachment :avatar

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
