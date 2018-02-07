class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.string :name
      t.string :action
      t.boolean :repeat, default: false
      t.integer :hour
      t.integer :minute
      t.json :repeat_days, default: [
          {day: 1, run: false},
          {day: 2, run: false},
          {day: 3, run: false},
          {day: 4, run: false},
          {day: 5, run: false},
          {day: 6, run: false},
          {day: 7, run: false},
      ]
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
