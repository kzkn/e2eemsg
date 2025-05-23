class RoomsController < ApplicationController
  before_action :set_room, only: %i[show]

  def index
    @rooms = current_user.rooms.order(:id)
  end

  def show
  end

  private

  def set_room
    @room = current_user.rooms.find(params[:id])
  end
end
