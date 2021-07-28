class CreateCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :credentials do |t|
      t.string :external_id, unique: true
      t.string :public_key
      t.references :user, null: false, foreign_key: true
      t.string :nickname
      t.bigint :sign_count, null: false, default: 0

      t.timestamps
    end
  end
end
