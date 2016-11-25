class Question < ApplicationRecord
  include Votable
  include Commentable
  include Attachable

  belongs_to :user
  has_many :answers, -> { order("best DESC") }, dependent: :destroy
  has_many :subscribtions, as: :subscribable, dependent: :destroy
  has_many :subscribers, through: :subscribtions, source: :user

  validates :title, :body, :user_id, presence: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :subscribe_author

  private

  def subscribe_author
    user.subscribe(self)
  end
end
