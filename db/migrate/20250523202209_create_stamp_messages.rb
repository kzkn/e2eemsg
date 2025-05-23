class CreateStampMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :stamp_messages do |t|
      t.belongs_to :stamp, null: false, foreign_key: true

      t.timestamps
    end
  end
end
