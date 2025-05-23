class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.belongs_to :joinable, null: false, polymorphic: true
      t.timestamps
    end
  end
end
