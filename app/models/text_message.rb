# TODO: remove column: body
class TextMessage < ApplicationRecord
  include Sendable

  has_many :ciphers, as: :encryptable, dependent: :destroy

  def render_for(membership, view_context)
    cipher = ciphers.joins(:key_pair).find_by(key_pairs: { user_id: membership.user_id })
    if cipher
      view_context.render("messages/text_message", text_message: self, cipher:)
    else
      "not sent to you"
    end
  end
end
