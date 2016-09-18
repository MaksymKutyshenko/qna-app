class Question < ApplicationRecord
  has_many :answers, -> { order("best DESC") }, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true
end
