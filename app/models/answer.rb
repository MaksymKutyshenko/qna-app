class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

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
