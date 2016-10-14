require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:some_user) { create(:user) }
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

  describe 'PATCH #rate' do 
    context 'when user is not owner' do 
      before { answer.update(user: some_user) }

      it 'updates answer votes count' do 
        expect { patch :rate, id: answer, rating: 1, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'sets answer rating to be equal 1' do
        patch :rate, id: answer, rating: 1, format: :json
        expect(assigns(:votable).rating).to eq(1)
      end

      it 'sets answer rating to be equal -1' do
        patch :rate, id: answer, rating: -1, format: :json
        expect(assigns(:votable).rating).to eq(-1)
      end

      it 'responses with status code 200' do
        patch :rate, id: answer, rating: -1, format: :json
        expect(response.status).to eq(200)
      end
    end

    context 'when user is owner' do 
      it 'does not change vote count' do 
        expect { patch :rate, id: answer, format: :json }.to_not change(Vote, :count)
      end      

      it 'does not changes answer rating' do 
        patch :rate, id: answer, rating: 1, format: :json
        expect(assigns(:votable).rating).to eq(0)          
      end

      it 'requestes with code 403' do 
        patch :rate, id: answer, format: :json
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #unrate' do 
    context 'when user is not vote owner' do 
      it 'does not change vote count' do
        expect { delete :unrate, id: answer, format: :json }.to_not change(Vote, :count)
      end

      it 'responses with code 403' do 
        delete :unrate, id: answer, format: :json
        expect(response.status).to eq(403)
      end
    end

    context 'when user is vote owner' do 
      let!(:vote) { create(:vote, votable: answer, user: @user, rating: 1) }
      it 'removes users vote' do 
        expect { delete :unrate, id: answer, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'responses with code 200' do 
        delete :unrate, id: answer, format: :json
        expect(response.status).to eq(200)
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
