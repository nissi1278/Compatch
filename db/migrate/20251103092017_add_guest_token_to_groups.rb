class AddGuestTokenToGroups < ActiveRecord::Migration[8.0]
  def change

    # グループの作成者管理はsession_id自体ではなく、secureなtokenを使用する。
    add_column :groups, :guest_token, :string, null: false
    add_index :groups, :guest_token

    # session_id(sessionsテーブルの外部キー)は削除する。
    remove_reference :groups, :session_id, if_exists: true, foreign_key: true
    remove_column :groups, :session_id, if_exists: true
  end
end
