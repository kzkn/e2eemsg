class SessionsController < ApplicationController
  skip_before_action :authenticate!, only: %i[new create]
  before_action :skip_if_authenticated, only: %i[new create]

  def new
  end

  def create
    user = User.find_or_initialize_by(email: params[:email])
    if user.persisted?
      user = User.where(id: user.id, encrypted_password: params[:encrypted_password])
    else
      user.name = params[:email].split("@")[0]
      user.encrypted_password = params[:encrypted_password]
      user.save!
    end

    if user
      user.key_pairs.create!(
        public_key: params[:public_key],
        encrypted_private_key: params[:encrypted_private_key],
        encrypted_private_key_iv: params[:encrypted_private_key_iv],
      )

      new_session = Session.create!(user:)
      session[:current_session_id] = new_session.id
      redirect_to root_url, notice: "ログインしました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @back_to = params[:back_to]
  end

  def update
    @back_to = params[:back_to]
    if current_user.encrypted_password == params[:encrypted_password]
      redirect_to params[:back_to] || root_url, notice: "再認証しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    session_id = session.delete(:current_session_id)
    Session.find_by(id: session_id)&.destroy
    redirect_to new_session_url, notice: "ログアウトしました", status: :see_other
  end

  private

  def skip_if_authenticated
    if (sess = Session.find_by(id: session[:current_session_id])).present?
      redirect_to root_url
    end
  end
end
