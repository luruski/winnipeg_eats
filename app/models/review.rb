class Review < ApplicationRecord
  belongs_to :restaurant

  validates :author, presence: true
  validates :rating, presence: true
  # ratings should only be 1 to 5
  validates :rating, numericality: { only_integer: true, in: 1..5 }
end