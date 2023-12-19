class UserSessionsController < ApplicationController
  def new
    if current_user
      redirect_to :vote
    end
  end

  def create
    email = params.require(:email)
    zip_code = params.require(:zip_code)

    user = User.find_or_initialize_by(email: email)

    user.update!(zip_code: zip_code) unless user.zip_code == zip_code
    session[:user_id] = user.id
    session[:expires_at] = 5.minutes.from_now

    redirect_to :vote
  end

  def destroy
    clear_session!

    redirect_to :login, notice: 'You have successfully logged out.'
  end
end
