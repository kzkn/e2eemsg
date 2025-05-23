class Emoji < ApplicationRecord
  has_many :reactions, dependent: :restrict_with_error

  def render
    definition["unicode"]
  end

  class << self
    def retrieve_by_json(emoji_picker_json)
      name = emoji_picker_json.dig("emoji", "annotation")
      Emoji.create_or_find_by!(name:) do |e|
        e.definition = emoji_picker_json
      end
    end
  end
end
