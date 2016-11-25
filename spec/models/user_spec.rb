require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribtions).dependent(:destroy) }

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

  describe '.send_daily_digest' do
    let!(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, user: users.first) }

    it 'should send daily digest to all users' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
      end
      User.send_daily_digest
    end
  end

  describe 'subscribed?' do
    let!(:user) { create(:user) }
    let!(:subscriber) { create(:user) }
    let!(:subscribable) { create(:question) }
    let!(:subscribtion) { create(:subscribtion, subscribable: subscribable, user: subscriber) }

    it 'returns true if user is subscribed' do
      expect(subscriber.subscribed?(subscribable)).to be_truthy
    end
    it 'returns nil if user is not subscribed' do
      expect(user.subscribed?(subscribable)).to be_falsey
    end
  end

  describe 'subscribtion_for' do
    let!(:user) { create(:user) }
    let!(:subscriber) { create(:user) }
    let!(:subscribable) { create(:question) }
    let!(:subscribtion) { create(:subscribtion, subscribable: subscribable, user: subscriber) }

    it 'returns subscribtion' do
      expect(subscriber.subscribtion_for(subscribable)).to eq subscribtion
    end
    it 'returns nil' do
      expect(user.subscribtion_for(subscribable)).to be_falsey
    end
  end

  describe 'subscribe' do
    let!(:subscriber) { create(:user) }
    let!(:subscribable) { create(:question) }

    it 'subscribes to subscribable' do
      expect { subscriber.subscribe(subscribable) }.to change(Subscribtion, :count).by(1)
    end
    it 'does not subscribe twice' do
      expect {
        subscriber.subscribe(subscribable)
        subscriber.subscribe(subscribable)
      }.to change(Subscribtion, :count).by(1)
    end
  end  
end
