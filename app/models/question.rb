class Question < ApplicationRecord
  include Votable
  
  belongs_to :user
  has_many :answers, -> { order("best DESC") }, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :title, :body, :user_id, presence: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
