class Ingredient < ApplicationRecord
  has_many :meal_ingredients
  has_many :meals, through: :meal_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true
end