class CreateBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :blocks do |t|
      t.belongs_to :blocker, null: false, foreign_key: { to_table: :users }, index: false
      t.belongs_to :blockee, null: false, foreign_key: { to_table: :users }

      t.timestamps
      t.index %i[blocker_id blockee_id], unique: true
    end
  end
end
