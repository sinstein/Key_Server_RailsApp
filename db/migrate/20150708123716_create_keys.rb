class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :value
      t.integer :alive_time
      t.integer :block_time

      t.timestamps null: false
    end
  end
end
