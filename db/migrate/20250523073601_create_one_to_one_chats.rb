class CreateOneToOneChats < ActiveRecord::Migration[8.0]
  def change
    create_table :one_to_one_chats do |t|
      t.belongs_to :smaller_user, null: false, foreign_key: { to_table: :users }, index: false
      t.belongs_to :larger_user, null: false, foreign_key: { to_table: :users }
      t.timestamps

      t.index %i[smaller_user_id larger_user_id], unique: true
    end
  end
end
