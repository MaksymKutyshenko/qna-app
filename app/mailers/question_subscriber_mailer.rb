class QuestionSubscriberMailer < ApplicationMailer
  def notify(subscriber, question)
    @url = question_url(question)
    mail to: subscriber.email, subject: "New answer for question #{question.title}"
  end
end
