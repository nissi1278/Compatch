class AddNotNullToSessionIdOnGroups < ActiveRecord::Migration[8.0]
  def change
    execute "UPDATE `groups` SET `session_id` = '' WHERE `session_id` IS NULL"
    change_column_null :groups, :session_id, false
  end
end
