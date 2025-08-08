class AddNotNullAndDefaultToTotalPriceOnGroups < ActiveRecord::Migration[8.0]
  def change
    execute "UPDATE `groups` SET `total_price` = 0 WHERE `total_price` IS NULL "
    change_column_default :groups, :total_price, from: nil, to: 0
    change_column_null :groups, :total_price, false
  end
end
