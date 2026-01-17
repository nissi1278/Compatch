class CreateUserIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :sub, null: false
      t.timestamps
    end

    # providerごとのsubは必ず一意になるが、DB側でもunique設定
    add_index :user_identities, [:provider, :sub], unique: true
  end
end
