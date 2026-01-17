class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :auth_token, null: false, index: {unique: true}
      t.boolean :is_guest, default: false, null: false
      t.timestamps
    end
  end
end
