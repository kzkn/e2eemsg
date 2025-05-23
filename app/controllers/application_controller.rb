class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate!

  helper_method :current_user, :user_signed_in?

  private

  def authenticate!
    if (sess = Session.find_by(id: session[:current_session_id])).present?
      Current.session = sess
    else
      redirect_to new_session_url
    end
  end

  def current_user
    Current.user
  end

  def user_signed_in?
    Current.session.present?
  end
end
