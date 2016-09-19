require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  let!(:question) { create(:question) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

  it 'creates best answer' do 
    answer1.best!
    expect(answer1.best).to eq true
  end

  it 'creates only one best onswer' do 
    answer1.best!
    answer2.best!

    answer1.reload
    answer2.reload

    expect(answer1.best).to eq false
    expect(answer2.best).to eq true
  end
end