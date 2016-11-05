require 'rails_helper'

describe Ability do 
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do 
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do 
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let!(:other) { create(:user) }

    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let!(:answer_vote) { create(:vote, votable: answer, user: user, rating: 1) }
    let!(:question_vote) { create(:vote, votable: question, user: user, rating: 1) }
    
    let!(:other_question) { create(:question, user: other) }
    let!(:other_answer) { create(:answer, question: other_question, user: other) }
    let!(:other_attachment) { create(:attachment, attachable: other_question) }
    let!(:other_answer_vote) { create(:vote, votable: answer, user: other, rating: 1) }
    let!(:other_question_vote) { create(:vote, votable: question, user: other, rating: 1) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Vote }

    it { should be_able_to :destroy, attachment, user: user }
    it { should_not be_able_to :destroy, other_attachment, user: user }

    it { should be_able_to :best, answer, user: user }
    it { should_not be_able_to :best, other_answer, user: user }

    context 'when user is not votable author' do 
      it { should be_able_to :rate, other_question, user: user }
      it { should be_able_to :rate, other_answer, user: user }
    end
    
    context 'when user is votable author' do 
      it { should_not be_able_to :rate, question, user: user }
      it { should_not be_able_to :rate, answer, user: user }
    end

    context 'when user voted for votable' do 
      it { should be_able_to :unrate, answer, user: user }
      it { should be_able_to :unrate, question, user: user }
    end

    context 'when user is owner' do 
      it { should be_able_to :update, question, user: user }
      it { should be_able_to :update, answer, user: user }
      it { should be_able_to :update, answer_vote, user: user }      
      it { should be_able_to :update, question_vote, user: user }      
    end

    context 'when user is not owner' do    
      it { should_not be_able_to :update, other_question, user: user }
      it { should_not be_able_to :update, other_answer, user: user }
      it { should_not be_able_to :update, other_answer_vote, user: user }
      it { should_not be_able_to :update, other_question_vote, user: user }
    end
  end
end