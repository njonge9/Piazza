class AddPasswordResetTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.string :password_reset_token_digest
    end
  end
end
