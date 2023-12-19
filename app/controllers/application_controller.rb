class ApplicationController < ActionController::Base
  private

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def authenticate_user!
    unless current_user
      redirect_to :login, alert: 'You must be signed in to do that.'
    end
  end

  def validate_session!
    if session[:expires_at] && session[:expires_at] < Time.current
      clear_session!
      redirect_to :login, alert: 'Your session expired. Sign in again to resume voting.'
    end
  end

  def clear_session!
    session[:user_id] = nil
    session[:expires_at] = nil
  end
end
