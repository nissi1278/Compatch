class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name, null: false, default: ''
      t.boolean :is_manual_fixed, null: false, default: false
      t.integer :payment_amount, null: false, default: 0
      t.timestamps
    end
  end
end
