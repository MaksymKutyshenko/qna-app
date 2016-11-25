require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscribtions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscribtions).source(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should accept_nested_attributes_for(:attachments) }
  it { should be_a_kind_of(Votable) }
  it { should be_a_kind_of(Commentable) }
  it { should be_a_kind_of(Attachable) }

  let!(:user) { create(:user) }
  let(:question) { build(:question, user: user) }

  it 'subscribes author for question after create' do
    expect(user).to receive(:subscribe).with(question)
    question.save!
  end

  it 'does not subscribe author for question after update' do
    question.save!
    expect(user).to_not receive(:subscribe).with(question)
    question.update(body: 'New body' )
  end
end
