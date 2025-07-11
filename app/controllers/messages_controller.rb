class MessagesController < ApplicationController
  include InRoomResource

  before_action :set_room
  before_action :set_message, only: %i[show]
  after_action :create_message_read, only: %i[show]

  def index
    @last_id = params[:last_id]
    @viewable_messages = @room.viewable_messages_for(current_membership)
    @messages = @viewable_messages.order(id: :desc).limit(5).then { @last_id.present? ? _1.where("messages.id < ?", @last_id) : _1 }
  end

  def show
    if current_user.block_by_self?(@message.from.user)
      head :no_content
    end
  end

  private

  def set_message
    @message = @room.messages.find(params[:id])
  end

  def create_message_read
    current_membership.message_reads.create_or_find_by!(message: @message)
  end
end
