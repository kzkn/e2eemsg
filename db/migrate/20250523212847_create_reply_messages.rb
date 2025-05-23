class CreateReplyMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :reply_messages do |t|
      t.belongs_to :reply_to, foreign_key: { to_table: :messages }
      t.string :body, null: false

      t.timestamps
    end
  end
end
