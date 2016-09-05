require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }    
  
  describe 'POST #create' do
    context 'when params are valid' do
      it 'saves new answer to db' do 
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change { question.answers.count }.by(1)
      end

      it 'assigns current user to answer' do
        post :create, answer: attributes_for(:answer), question_id: question 
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'redirects to question show view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'when params are invalid' do 
      it 'does not save answer to db' do 
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do     
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'when current user is owner' do
      it 'deletes question' do      
        expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
      end
      it 'redirects to question show view' do 
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end
    
    context 'when current user is not owner' do           
      let(:some_user) { create(:user) }
      let!(:some_answer) { create(:answer, question: question, user: some_user) }

      it 'does not delete question' do              
        expect { delete :destroy, question_id: question, id: some_answer }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do 
        delete :destroy, question_id: question, id: some_answer
        expect(response).to redirect_to question
      end
    end
  end
end
