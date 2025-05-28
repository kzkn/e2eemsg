class CreateKeyPairs < ActiveRecord::Migration[8.0]
  def change
    create_table :key_pairs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :public_key, null: false
      t.string :encrypted_private_key, null: false

      t.timestamps
    end
  end
end
