class ReplyMessagesController < ApplicationController
  include InRoomResource

  before_action :set_room

  def create
    message = @room.messages.build(from: current_membership)
    message.sendable = ReplyMessage.new(reply_message_params)
    message.save!

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to room_url(@room)
      end
    end
  end

  private

  def reply_message_params
    params.expect(reply_message: %i[reply_to_id body])
  end
end
