class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.order(:name)

    # simple text search on the name (feature 4.1)
    if params[:search].present?
      @restaurants = @restaurants.where("name LIKE ?", "%#{params[:search]}%")
    end

    # narrow the search down to one cuisine (feature 4.2)
    if params[:cuisine_id].present?
      @restaurants = @restaurants.joins(:cuisines).where(cuisines: { id: params[:cuisine_id] })
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end