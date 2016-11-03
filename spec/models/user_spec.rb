require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do 
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authentication' do
      it 'returns the user' do 
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do 
      context 'user already exists' do 
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do 
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do 
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do 
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do 
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@email.com' }) }

        it 'creates new user' do 
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do 
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do 
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info['email']
        end

        it 'creates authorization for user' do 
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do 
          authentication = User.find_for_oauth(auth).authorizations.first

          expect(authentication.provider).to eq auth.provider
          expect(authentication.uid).to eq auth.uid
        end
      end

      context 'when email in auth hash is empty' do 
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {}) }
        it 'returns new user instance' do 
          user = User.find_for_oauth(auth)
          expect(user).to be_a_new(User)
        end
      end
    end
  end
end