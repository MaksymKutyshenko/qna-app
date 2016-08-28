require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }    
  
  describe 'GET #new' do 
    before { get :new, question_id: question }    

    it 'assignes new answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'it renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
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

  describe 'DELETE #destroy' do     
    let!(:answer) { create(:answer, user: @user, question: question) }

    context 'when current user is owner' do
      it 'deletes question' do      
        expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
      end
    end
    
    context 'when current user is not owner' do           
      let(:some_user) { create(:user) }
      let(:some_answer) { create(:answer, question: question, user: some_user) }

      it 'does not delete question' do              
        expect { delete :destroy, question_id: question, id: some_answer }.to_not change(Question, :count)
      end
    end
    it 'redirect to index view' do 
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end
