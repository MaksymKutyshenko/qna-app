require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:gon) { RequestStore.store[:gon].gon }

  describe 'GET #index' do    
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'pupulaes an array of all questions' do 
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index  
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do 
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do 
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'assigns @question to gon.question' do 
      expect(gon['question']).to eq question
    end

    it 'renders show view' do 
      expect(response).to render_template :show  
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @qestion' do 
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do 
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end 

  describe 'POST #create' do
    sign_in_user
    context 'when attributes are valid' do 
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'assigns current user to question' do
        post :create, question: attributes_for(:question) 
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do 
         post :create, question: attributes_for(:question)
         expect(response).to redirect_to question_path(assigns(:question)) 
      end
    end

    context 'when attributes are invalid' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end  

  describe 'PATCH #update' do 
    sign_in_user
    before { question.update(user: @user) }

    context 'valid attributes' do 
      before { patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js }

      it 'assigns the requested question to @question' do 
        expect(assigns(:question)).to eq question
      end
      
      it 'changes question attributes' do 
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'when invalid attributes' do 
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change question attributes' do 
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq nil
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'when current user is not owner' do 
      let(:some_user) { create(:user) }

      it 'does not change question attributes' do 
        question.update(user: some_user)
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #rate' do
    sign_in_user

    context 'when user is not owner' do 
      it 'updates question votes count' do 
        expect { patch :rate, id: question, rating: 1, format: :json }.to change(question.votes, :count).by(1)
      end

      it 'sets question rating to be equal 1' do
        patch :rate, id: question, rating: 1, format: :json
        expect(assigns(:votable).rating).to eq(1)
      end

      it 'sets question rating to be equal -1' do
        patch :rate, id: question, rating: -1, format: :json
        expect(assigns(:votable).rating).to eq(-1)
      end

      it 'responses with status code 200' do
        patch :rate, id: question, rating: -1, format: :json
        expect(response.status).to eq(200)
      end
    end

    context 'when user is owner' do 
      before { question.update(user: @user) }

      it 'does not sets question rating' do 
        patch :rate, id: question, rating: 1, format: :json
        expect(assigns(:votable).rating).to eq(0)          
      end
      it 'responses with status 403' do
        patch :rate, id: question, rating: 1, format: :json
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #unrate' do
    sign_in_user
    let!(:question) { create(:question) }

    context 'when user is vote owner', format: :json do 
      let!(:vote) { create(:vote, user: @user, rating: 1, votable: question) }
      it 'remove question vote' do
        expect { delete :unrate, id: question }.to change(Vote, :count).by(-1)
      end
      
      it 'responses with status 200' do 
        expect(response.status).to eq(200)
      end  
    end

    context 'when user is not vote owner', format: :json do 
      it 'does not delete vote' do
        expect { delete :unrate, id: question }.to_not change(Vote, :count)
      end

      it 'responses with status 403' do 
        delete :unrate, id: question
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #destroy' do 
    sign_in_user

    context 'when current user is owner' do
      before { question.update_attribute(:user_id, @user.id) }
      it 'deletes question' do      
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do 
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'when current user is not owner' do
      let!(:some_user) { create(:user_with_questions) }
      it 'does not delete question' do              
        expect { delete :destroy, id: some_user.questions.first }.to_not change(Question, :count)
      end

      it 'redirects to index' do 
        delete :destroy, id: some_user.questions.first
        expect(response).to redirect_to questions_path
      end
    end
  end
end
