class MealsController < ApplicationController
  def index
    @meals = Meal.order(:name).page(params[:page]).per(24)
  end

  def show
    @meal = Meal.find(params[:id])
  end
end