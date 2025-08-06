class AddNameToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :name, :string
  end
end
