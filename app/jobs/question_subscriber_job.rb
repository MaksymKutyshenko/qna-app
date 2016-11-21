class QuestionSubscriberJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscribers.each do |subscriber|
      QuestionSubscriberMailer.notify(subscriber, question).deliver_later
    end
  end
end
