class RemoveGuestTokenFromGroups < ActiveRecord::Migration[8.0]
  def change
    remove_column :groups, :guest_token, :string
  end
end
