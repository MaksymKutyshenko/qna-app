require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question) }    
  let!(:answer) { create(:answer, user: @user, question: question) }
  
  describe 'POST #create' do
    context 'when params are valid' do
      it 'saves new answer to db' do 
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change { question.answers.count }.by(1)
      end

      it 'assigns current user to answer' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js 
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'renders create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'when params are invalid' do 
      it 'does not save answer to db' do 
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do 

    context 'when current user is owner' do 
      it 'assings the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end
     
      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'when current user is not owner' do 
      let(:some_user) { create(:user) }

      it 'does not change answer attribute' do 
        answer.update(user: some_user)
        patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end
  

  describe 'DELETE #destroy' do     

    context 'when current user is owner' do
      it 'deletes answer' do      
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
      it 'renders destroy template' do 
        delete :destroy, question_id: question, id: answer, format: :js 
        expect(response).to render_template :destroy
      end
    end
    
    context 'when current user is not owner' do           
      let(:some_user) { create(:user) }
      let!(:some_answer) { create(:answer, question: question, user: some_user) }

      it 'does not delete answer' do              
        expect { delete :destroy, question_id: question, id: some_answer, format: :js }.to_not change(Answer, :count)
      end
      it 'renders destroy template' do 
        delete :destroy, question_id: question, id: some_answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #best' do     

    context 'when current user is owner of question' do 
      before do
        question.update(user: @user)
        post :best, id: answer, format: :js
      end

      it 'assigns requested answer to answer' do 
        expect(assigns(:answer)).to eq answer     
      end

      it 'assigns answers question to question' do 
        expect(assigns(:question)).to eq answer.question     
      end

      it 'updates best attribute of answer' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders best.js template' do 
        expect(response).to render_template :best
      end
    end

    context 'when current user is not owner of question' do 
      before { post :best, id: answer, format: :js }

      it 'does not update best attribute of answer' do 
        expect(assigns(:answer).best).to_not eq true
      end

      it 'renders best.js template' do 
        expect(response).to render_template :best
      end
    end
  end
end
