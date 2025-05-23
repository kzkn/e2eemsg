class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.belongs_to :room, null: false, foreign_key: true
      t.belongs_to :from, null: false, foreign_key: { to_table: :memberships }
      t.belongs_to :sendable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
