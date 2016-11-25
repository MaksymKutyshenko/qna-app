# Preview all emails at http://localhost:3000/rails/mailers/question_subscriber
class QuestionSubscriberPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_subscriber/notify
  def notify
    QuestionSubscriberMailer.notify
  end

end
