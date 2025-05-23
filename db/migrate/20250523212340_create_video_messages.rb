class CreateVideoMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :video_messages do |t|
      t.timestamps
    end
  end
end
