class RepoController < ApplicationController
  include GitRequest

  def login
  end

  def repos
    token = validate_session(params[:token])
    @repos = GitRequest.repos(token)
  end

  def issues
    token = validate_session(params[:token])
    @issues = GitRequest.issues(token, params[:repo])
  end

  private

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
