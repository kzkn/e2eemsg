class CreateGroupChats < ActiveRecord::Migration[8.0]
  def change
    create_table :group_chats do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
