class MealsController < ApplicationController
  def index
    @meals = Meal.order(:name)
  end

  def show
    @meal = Meal.find(params[:id])
  end
end