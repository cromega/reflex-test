class CreateCounters < ActiveRecord::Migration[6.1]
  def change
    create_table :counters do |t|
      t.string :name
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
