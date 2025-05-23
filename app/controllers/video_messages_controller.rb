class VideoMessagesController < ApplicationController
  include InRoomResource

  before_action :set_room

  def create
    message = @room.messages.build(from: current_membership)
    message.sendable = VideoMessage.new(video_message_params)
    message.save!

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to room_url(@room)
      end
    end
  end

  private

  def video_message_params
    params.expect(video_message: %i[video])
  end
end
