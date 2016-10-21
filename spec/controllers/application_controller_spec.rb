require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do 

  let(:user) { create(:user) }
  let(:gon) { RequestStore.store[:gon].gon }

  context 'when user is signed in' do
    it 'sets gon.user_id to be eq signed user id' do
      sign_in(user)
      subject.send(:gon_user)
      expect(gon['user_id']).to eq(user.id)  
    end
  end

  context 'when user is guest' do 
    it 'sets gon.user_id to be eq nil' do 
      subject.send(:gon_user)
      expect(gon['user_id']).to eq(nil) 
    end
  end
end
