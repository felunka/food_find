class RemoveUserNicknameFromCredentials < ActiveRecord::Migration[6.0]
  def change
    remove_column :credentials, :nickname, :string
    remove_column :credentials, :user_id, :references
  end
end
