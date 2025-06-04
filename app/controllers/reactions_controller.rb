class ReactionsController < ApplicationController
  include InRoomResource

  before_action :set_room
  before_action :set_message

  def create
    emoji_picker_json = JSON.parse(params[:emoji])
    emoji = Emoji.retrieve_by_json(emoji_picker_json)
    Reaction.toggle!(message: @message, from: current_membership, emoji:)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to room_url(@room)
      end
    end
  end

  private

  def set_message
    @message = @room.messages.find(params[:message_id])
  end
end
