class Cuisine < ApplicationRecord
  # a cuisine can belong to many restaurants and vice versa
  has_many :restaurant_cuisines
  has_many :restaurants, through: :restaurant_cuisines

  # one cuisine has many meals (like Italian has lasagna, carbonara etc)
  has_many :meals

  validates :name, presence: true
  validates :name, uniqueness: true
end