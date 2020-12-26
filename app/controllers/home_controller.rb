class HomeController < ApplicationController
  def index
    @left = create_counter("left")
    @right = create_counter("right")
  end

  private

  def create_counter(name)
    Counter.find_or_create_by(name: name)
  end
end
