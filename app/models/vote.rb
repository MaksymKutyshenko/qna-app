class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true
  validates :rating, inclusion: -1..1
  validates :user_id, presence: true
end
