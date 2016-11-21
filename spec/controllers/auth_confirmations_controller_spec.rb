require 'rails_helper'

RSpec.describe AuthConfirmationsController, type: :controller do

  describe 'GET #new' do
    it 'renders new template' do
      get :new, params: { provider: 'twitter', uid: '123456' }
      expect(request).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'redirects to new user session path' do
      post :create, params: { email: 'some@email.com' }
      expect(request).to redirect_to new_user_session_path
    end
  end

  describe 'POST #finish' do
    context 'when params are valid' do
      before do
        session[:omniauth] = { 'provider' => 'twitter', 'uid' => '123456', 'auth_token' => '654321' }
        get :finish, params: { email: 'some@email.com', auth_token: '654321' }
      end

      it 'assigns created user to @user' do
        expect(assigns(:user).persisted?).to eq(true)
      end
      it 'deletes session[:omniauth] hash' do
        expect(session[:omniauth]).to eq(nil)
      end
    end

    context 'when params are not valid' do
      before { get :finish, params: { email: '', auth_token: 'wrong-token' } }
      it 'assigns @user to nil' do
        expect(assigns(:user)).to eq(nil)
      end
      it 'redirects to new user session path' do
        expect(request).to redirect_to new_user_session_path
      end
      it 'deletes session[:omniauth] hash' do
        expect(session[:omniauth]).to eq(nil)
      end
    end

  end
end
