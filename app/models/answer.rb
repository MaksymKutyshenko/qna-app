class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Attachable

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def best!
    ActiveRecord::Base.transaction do
      best_answer = question.answers.find_by(best: true)
      if best_answer.present?
        best_answer.update!(best: false)
      end
      update!(best: true)
    end
  end
end
