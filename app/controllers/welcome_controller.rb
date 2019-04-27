class WelcomeController < ApplicationController
  include GitRequest

  def index
    @sample = GitRequest.hello
  end
end
