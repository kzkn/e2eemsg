class CreateStamps < ActiveRecord::Migration[8.0]
  def change
    create_table :stamps do |t|
      t.belongs_to :stamp_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
