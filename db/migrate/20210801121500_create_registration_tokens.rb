class CreateRegistrationTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :registration_tokens do |t|
      t.string :auth_token

      t.timestamps
    end
    add_index :registration_tokens, :auth_token, unique: true
  end
end
