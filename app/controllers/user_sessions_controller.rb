class UserSessionsController < ApplicationController
  def new
    if current_user
      redirect_to :vote
    end

    @show_results_link = true
  end

  def create
    email = params.require(:email)
    zip_code = params.require(:zip_code)

    user = User.find_or_initialize_by(email: email)

    if Vote.exists?(user_id: user.id)
      redirect_to :results, notice: 'Your vote has already been recorded.'
    else
      user.update!(zip_code: zip_code) unless user.zip_code == zip_code
      session[:user_id] = user.id
      session[:expires_at] = 5.minutes.from_now

      redirect_to :vote
    end
  end

  def destroy
    clear_session!

    flash_message =
      if params[:expired]
        { alert: 'Your session expired. Sign in again to resume voting.' }
      else
        { notice: 'You have successfully logged out.' }
      end

    redirect_to :login, flash_message
  end
end
