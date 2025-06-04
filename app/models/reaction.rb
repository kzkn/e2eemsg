class Reaction < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :message
  belongs_to :from, class_name: "Membership", inverse_of: :sent_reactions
  belongs_to :emoji

  after_commit :broadcast_replace

  private

  def broadcast_replace
    broadcast_replace_to message.room, target: dom_id(message, :reactions), partial: "messages/reactions", locals: { message: }
  end

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
