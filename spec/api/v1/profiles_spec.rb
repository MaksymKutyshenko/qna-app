require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it "contains all users except current" do
        expect(response.body).to eq(User.where.not(id: me.id).to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
