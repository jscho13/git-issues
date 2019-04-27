class ApplicationController < ActionController::Base
  # 1. Would like to reset sessions on re-login, to avoid session fixation hacks.
  # https://stackoverflow.com/questions/4812813/rails-login-reset-session
  def validate_session(new_token)
    session[:token] = new_token || session[:token]
    if session[:token]
      return session[:token]
    else
      redirect_to('/login')
    end
  end
end
