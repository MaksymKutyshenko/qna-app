require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }  

  describe 'GET #new' do 
    sign_in_user
    before { get :new, question_id: question }    

    it 'assignes new answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'it renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    sign_in_user
    context 'when params are valid' do
      it 'saves new answer to db' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change { question.answers.count }.by(1)
      end

      it 'redirects to question view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'when params are invalid' do 
      it 'does not save answer to db' do 
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 'renders new view' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end
end
