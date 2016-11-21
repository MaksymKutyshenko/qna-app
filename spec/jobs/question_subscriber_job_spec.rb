require 'rails_helper'

RSpec.describe QuestionSubscriberJob, type: :job do
  let(:subscriber1) { create(:user) }
  let(:subscriber2) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscribtion1) { create(:subscribtion, subscribable: question, user: subscriber1 ) }
  let!(:subscribtion2) { create(:subscribtion, subscribable: question, user: subscriber2 ) }

  it 'sends notification to question subscribers' do
    question.subscribers.each do |subscriber|
      expect(QuestionSubscriberMailer).to receive(:notify).with(subscriber, question).and_call_original
    end
    QuestionSubscriberJob.perform_now(question)
  end
end
