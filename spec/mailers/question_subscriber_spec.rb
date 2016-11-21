require "rails_helper"

RSpec.describe QuestionSubscriberMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, subscribable: question, user: user) }

    let(:mail) { QuestionSubscriberMailer.notify(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for question #{question.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@qna.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for question #{question_url(question)}")
    end
  end
end
