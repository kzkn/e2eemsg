class CreateCiphers < ActiveRecord::Migration[8.0]
  def change
    create_table :ciphers do |t|
      t.belongs_to :key_pair, null: false, foreign_key: true
      t.belongs_to :encryptable, null: false, foreign_key: false, polymorphic: true
      t.string :cipher_body, null: false
      t.string :iv, null: false
      t.string :encrypted_key, null: false

      t.timestamps
    end
  end
end
