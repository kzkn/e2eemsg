class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    last_id = params[:last_id]
    @users = User.without(current_user).order(:id).then { last_id.present? ? _1.where("id > ?", last_id) : _1 }
  end

  def show
    chat = OneToOneChat.find_or_create_for_users(current_user, @user)
    redirect_to room_path(chat.room)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
