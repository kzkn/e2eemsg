module InRoomResource
  extend ActiveSupport::Concern

  included do
    helper_method :current_membership
  end

  private

  def set_room
    @room = current_user.rooms.find(room_id)
  end

  def room_id
    params[:room_id]
  end

  def current_membership
    @current_membership ||= current_user.memberships.find_by!(room: @room)
  end
end
