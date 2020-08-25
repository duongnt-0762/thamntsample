class Micropost < ApplicationRecord
  has_many :microposts
  belongs_to :user
  has_one_attached :image
  scope :order_by_time, -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
