class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :created_at, null: false
      t.string   :level,       null: false  # debug, info, warn, error, fatal
      t.string   :category,   null: false  # Additional type information, eg. "invalid_params_passed"
      t.string   :message,    null: false
      t.integer  :user_id
      t.string   :controller
      t.string   :action
      t.json   :data
      t.string   :notes
    end
  end
end
