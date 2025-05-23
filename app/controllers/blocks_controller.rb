class BlocksController < ApplicationController
  before_action :set_user

  def create
    current_user.blocks_by_self.create_or_find_by!(blockee: @user)
    redirect_back fallback_location: root_url
  end

  def destroy
    current_user.blocks_by_self.find_by(blockee: @user)&.destroy!
    redirect_back fallback_location: root_url, status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
