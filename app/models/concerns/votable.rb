module Votable
  extend ActiveSupport::Concern

  included do 
    has_many :votes, as: :votable, dependent: :destroy 
  end

  def rate(user, rating)
    vote = votes.find_or_create_by(user: user)
    vote.update(rating: rating)
  end

  def unrate(user)
    vote = votes.find_by(user: user)
    vote.destroy if vote.present?
  end

  def rating
    votes.sum(:rating)
  end
end