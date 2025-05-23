class CreateMessageReads < ActiveRecord::Migration[8.0]
  def change
    create_table :message_reads do |t|
      t.belongs_to :message, null: false, foreign_key: true, index: false
      t.belongs_to :membership, null: false, foreign_key: true

      t.timestamps
      t.index %i[message_id membership_id], unique: true
    end
  end
end
