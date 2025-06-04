class Reaction < ApplicationRecord
  belongs_to :message
  belongs_to :from, class_name: "Membership", inverse_of: :sent_reactions
  belongs_to :emoji

  # TODO: stream でリアルタイムに画面に反映したい

  class << self
    def toggle!(message:, from:, emoji:)
      reaction = Reaction.find_or_initialize_by(message:, from:, emoji:)
      if reaction.persisted?
        reaction.destroy!
      else
        reaction.save!
      end
    end
  end
end
