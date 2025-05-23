class CreateImageMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :image_messages do |t|
      t.timestamps
    end
  end
end
