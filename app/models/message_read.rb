class MessageRead < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :message
  belongs_to :membership

  after_commit :broadcast_update

  private

  def broadcast_update
    room = message.room
    message.room.memberships.each do |membership|
      broadcast_update_to membership, target: dom_id(message, :reads), html: room.read_count_text(message, membership)
    end
  end
end
