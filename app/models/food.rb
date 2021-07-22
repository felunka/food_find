class Food < ApplicationRecord
  has_many :food_tags
  has_many :tags, through: :food_tags, dependent: :destroy

  validates :name, presence: true
end
