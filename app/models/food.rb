class Food < ApplicationRecord
  has_many :food_tags
  has_many :tags, through: :food_tags

  validates :name, presence: true
end
