require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'when user is signd in' do
      before { sign_in(user) }

      it 'assigns requested question to @commentable' do
        post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
        expect(assigns(:commentable)).to eq(question)
      end

      it 'assigns requested answer to @commentable' do
        post :create, params: { comment: { body: 'New answer comment'}, answer_id: answer, format: :js }
        expect(assigns(:commentable)).to eq(answer)
      end

      it 'saves new comment to db' do
        expect {
          post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
        }.to change(Comment, :count).by(1)
      end

      it 'does not save empty comment' do
        expect {
          post :create, params: { comment: { body: ''}, question_id: question, format: :js }
        }.to_not change(Comment, :count)
      end

      it 'renders create remplate' do
        post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
        expect(response).to render_template :create
      end

      it 'ActionCable.server should broadcast after creating' do
        expect(ActionCable.server).to receive(:broadcast)
        post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
      end
    end

    context 'when user is guest' do
      it 'does not save new comment to db' do
        expect {
          post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
        }.to_not change(Comment, :count)
      end

      it 'ActionCable.server should not broadcast after creating' do
        expect(ActionCable.server).to_not receive(:broadcast)
        expect {
          post :create, params: { comment: { body: 'New question comment'}, question_id: question, format: :js }
        }.to_not change(Comment, :count)
      end
    end
  end
end
