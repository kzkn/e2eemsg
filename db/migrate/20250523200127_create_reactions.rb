class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.belongs_to :message, null: false, foreign_key: true, index: false
      t.belongs_to :from, null: false, foreign_key: { to_table: :memberships }
      t.belongs_to :emoji, null: false, foreign_key: true

      t.timestamps
      t.index %i[message_id from_id emoji_id], unique: true
    end
  end
end
