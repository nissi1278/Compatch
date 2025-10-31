class AddShareTokenToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :share_token, :string
    add_index :groups, :share_token, unique: true
  end
end
