class CreateEmojis < ActiveRecord::Migration[8.0]
  def change
    create_table :emojis do |t|
      t.string :name, null: false, index: { unique: true }
      t.json :definition, null: false

      t.timestamps
    end
  end
end
