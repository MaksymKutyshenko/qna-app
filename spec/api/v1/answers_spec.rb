require 'rails_helper'

describe 'Answers API' do
  describe 'GET /' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }

    context 'unauthorized' do
      it 'returns status 401' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns status 401 if wrong access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returs status 200' do
        expect(response).to be_success
      end

      it 'returns a list of answers fo question ' do
        expect(response.body).to have_json_size(2)
      end

      %w(id question_id body created_at updated_at best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'anauthorized' do
      it 'returns status 401' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
      end

      it 'returns status 401 when invalid access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

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
  end

  describe 'POST /create' do
    let!(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns status 401' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer) }
        expect(response.status).to eq 401
      end

      it 'returns 401 when access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'when params are valid' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }

        it 'returns status 200' do
          expect(response).to be_success
        end

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
  end
end
