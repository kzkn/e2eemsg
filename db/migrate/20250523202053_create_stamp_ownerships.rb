class CreateStampOwnerships < ActiveRecord::Migration[8.0]
  def change
    create_table :stamp_ownerships do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: false
      t.belongs_to :stamp_set, null: false, foreign_key: true

      t.timestamps
      t.index %i[user_id stamp_set_id], unique: true
    end
  end
end
