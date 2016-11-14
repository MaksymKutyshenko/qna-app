require 'rails_helper'

describe 'Answers API' do
  describe 'GET /' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns a list of answers fo question ' do
        expect(response.body).to have_json_size(2)
      end

      %w(id question_id body created_at updated_at best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      %w(attachments comments).each do |attr|
        it "contains a list of #{attr}" do
          expect(response.body).to have_json_size(2).at_path(attr)
        end
      end

      %w(id question_id user_id body created_at updated_at best).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'when params are valid' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }

        %w(id question_id user_id body created_at updated_at best).each do |attr|
          it "new answer contains #{attr}" do
            expect(response.body).to be_json_eql(assigns(:answer).send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      context 'when params are not valid' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: { body: '' }, access_token: access_token.token } }

        it 'returns status 422' do
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer) }.merge(options)
    end
  end
end
