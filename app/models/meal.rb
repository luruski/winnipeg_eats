class Meal < ApplicationRecord
  belongs_to :cuisine

  has_many :meal_ingredients
  has_many :ingredients, through: :meal_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true
end