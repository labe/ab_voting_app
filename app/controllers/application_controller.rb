class ApplicationController < ActionController::Base
  private

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def clear_session!
    session[:user_id] = nil
    session[:expires_at] = nil
  end
end
