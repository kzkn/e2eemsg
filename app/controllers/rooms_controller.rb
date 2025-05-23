class RoomsController < ApplicationController
  include InRoomResource

  before_action :set_room, only: %i[show]

  def index
    @rooms = current_user.rooms.order(:id)
  end

  def show
  end

  private

  def room_id
    params[:id]
  end
end
