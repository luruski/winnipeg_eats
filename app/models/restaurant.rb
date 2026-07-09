class Restaurant < ApplicationRecord
  has_many :restaurant_cuisines
  has_many :cuisines, through: :restaurant_cuisines

  has_many :reviews

  validates :name, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
end