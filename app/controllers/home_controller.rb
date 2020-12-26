class HomeController < ApplicationController
  def index
    session[:counter] = 0
  end
end
