class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :session_id
      t.integer :total_price
      t.timestamps
    end
  end
end
