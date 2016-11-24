require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:gon) { RequestStore.store[:gon].gon }

  it_behaves_like 'voted', resource: :question

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
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
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

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'when attributes are valid' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'assigns current user to question' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
         post :create, params: { question: attributes_for(:question) }
         expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'should publish_question after creating' do
        expect(ActionCable.server).to receive(:broadcast)
        post :create, params: { question: attributes_for(:question) }
      end
    end

    context 'when attributes are invalid' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end

      it 'ActionCable.server should not broadcast after creating' do
        expect(ActionCable.server).to_not receive(:broadcast)
        post :create, params: { question: attributes_for(:invalid_question) }
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { question.update(user: @user) }

    context 'valid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js }

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
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil } }, format: :js }

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
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'when current user is owner' do
      before { question.update_attribute(:user_id, @user.id) }
      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'when current user is not owner' do
      let!(:some_user) { create(:user_with_questions) }
      it 'does not delete question' do
        expect { delete :destroy, params: { id: some_user.questions.first } }.to_not change(Question, :count)
      end

      it 'responses with status 403' do
        delete :destroy, params: { id: some_user.questions.first }, format: :json
        expect(response.status).to eq(403)
      end
    end
  end
end
