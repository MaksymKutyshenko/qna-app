require "rails_helper"

shared_examples "subscribed" do |options|

  let!(:subscribable) { create(options[:resource]) }

  describe "POST #subscribe" do
    context 'Authorized user' do
      sign_in_user

      it "changes subscriptions count for #{options[:resource]}" do
        expect{ post :subscribe, params: { id: subscribable, format: :json } }.to change(Subscribtion, :count).by(1)
      end
      it 'returns status 200 for unauthorized user' do
        post :subscribe, params: { id: subscribable, format: :json }
        expect(response).to be_success
      end
    end

    context 'Unauthorized user' do
      it 'returns status 401' do
        post :subscribe, params: { id: subscribable, format: :json }
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #unsubscribe" do
    context 'Authorized user' do
      sign_in_user
      let!(:subscribtion) { create(:subscribtion, subscribable: subscribable, user: @user) }

      it "changes subscriptions count for #{options[:resource]} by -1" do
        expect { delete :unsubscribe, params: { id: subscribable, format: :json } }.to change(Subscribtion, :count).by(-1)
      end
      it 'returns status 200 for unauthorized user' do
        post :unsubscribe, params: { id: subscribable, format: :json }
        expect(response).to be_success
      end
    end

    context 'Unauthorized user' do
      it 'returns status 401' do
        post :unsubscribe, params: { id: subscribable, format: :json }
        expect(response.status).to eq 401
      end
    end
  end
end
