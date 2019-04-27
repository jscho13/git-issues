class RepoController < ApplicationController
  include GitRequest

  def login
  end

  def repos
    token = validate_session(params[:token])
    user = GitRequest.user(token)

    cookies[:user] = user['login']
    repos = GitRequest.repos(token, user)

    @repos = repos
  end

  def issues
    token = validate_session(params[:token])
    user = cookies[:user]
    repo = params[:repo]
    sort_key = params[:sortKey]

    @issues = GitRequest.issues(token, user, repo, sort_key)
  end

end
