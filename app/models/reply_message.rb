class ReplyMessage < ApplicationRecord
  belongs_to :reply_to, class_name: "Message", inverse_of: :reply_messages, optional: true

  def render_for(membership, view_context)
    view_context.render("messages/reply_message", reply_message: self)
  end

  def valid_to_send?(message)
    message.room == reply_to.room
  end
end
