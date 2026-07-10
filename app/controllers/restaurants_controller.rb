class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.order(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end