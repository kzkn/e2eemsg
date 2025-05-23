class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :room
  belongs_to :from, class_name: "Membership", inverse_of: :sent_messages
  delegated_type :sendable, types: %w[TextMessage]
  has_many :message_reads, dependent: :destroy
  has_many :reactions, dependent: :destroy

  delegate :render_for, to: :sendable

  validate :require_valid_to_send
  after_create_commit :broadcast_append

  private

  def require_valid_to_send
    unless sendable.valid_to_send?(self)
      errors.add(:base, "not sendable")
    end
  end

  def broadcast_append
    broadcast_append_to room, target: dom_id(room), partial: "messages/placeholder", locals: { room:, message: self }
  end
end
