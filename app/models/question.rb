class Question < ApplicationRecord
  has_many :answers, -> { order("best DESC") }, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true
  accepts_nested_attributes_for :attachments
end
