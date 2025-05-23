class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :room
  belongs_to :from, class_name: "Membership", inverse_of: :sent_messages
  delegated_type :sendable, types: %w[TextMessage]
  has_many :message_reads, dependent: :destroy

  delegate :render_for, to: :sendable

  after_create_commit :broadcast_append

  private

  def broadcast_append
    broadcast_append_to room, target: dom_id(room), partial: "messages/placeholder", locals: { room:, message: self }
  end
end
