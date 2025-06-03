class AddEncryptedPrivateKeyIvToKeyPairs < ActiveRecord::Migration[8.0]
  def change
    add_column :key_pairs, :encrypted_private_key_iv, :string, null: false
  end
end
