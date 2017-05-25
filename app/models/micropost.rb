class Micropost < ApplicationRecord
  belongs_to :users
  validates :content, presence: true, length: { maximum: 140 }
end
