class Food < ApplicationRecord
  has_many :food_tags
  has_many :tags, through: :food_tags, dependent: :destroy

  has_one_attached :photo

  validates :name, presence: true

  def cropped_photo
    photo.variant(resize_to_limit: [320, 240] )
  end
end
