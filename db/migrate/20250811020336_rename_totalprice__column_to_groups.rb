class RenameTotalpriceColumnToGroups < ActiveRecord::Migration[8.0]
  def change
    rename_column :groups, :total_price, :total_amount
  end
end
