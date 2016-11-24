require "rails_helper"

RSpec.describe SubscribtionsController, type: :controller do

  let!(:question) { create(:question) }

  describe "POST #create" do
    context 'Authorized user' do
      sign_in_user

      it "changes subscriptions count for question" do
        expect{ post :create, params: { question_id: question.id, format: :js } }.to change(Subscribtion, :count).by(1)
      end
      it 'renders create.js.erb template' do
        post :create, params: { question_id: question.id, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'Unauthorized user' do
      it 'returns status 403' do
        post :create, params: { question_id: question.id, format: :js }
        expect(response.status).to eq 403
      end
    end
  end

  describe "DELETE #destroy" do
    context 'Authorized user' do
      sign_in_user
      let!(:subscribtion) { create(:subscribtion, subscribable: question, user: @user) }

      it "changes subscriptions count for question by -1" do
        expect { delete :destroy, params: { id: subscribtion, format: :js } }.to change(Subscribtion, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, params: { id: subscribtion, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthorized user' do
      let!(:subscribtion) { create(:subscribtion, subscribable: question) }
      it 'returns status 403' do
        post :destroy, params: { id: subscribtion, format: :js }
        expect(response.status).to eq 403
      end
    end
  end
end
