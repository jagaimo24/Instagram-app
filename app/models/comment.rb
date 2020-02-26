class Comment < ApplicationRecord
  has_many   :notifications, dependent: :destroy
  belongs_to :user
  belongs_to :micropost
  validates  :content, presence: true
end
