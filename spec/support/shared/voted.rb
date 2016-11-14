require 'rails_helper'

shared_examples 'voted' do |options|

  sign_in_user
  let!(:votable) { create(options[:resource], user: @user) }
  let!(:some_user) { create(:user) }

  describe 'PATCH #rate' do
    context 'when user is owner' do
      it 'does not change vote count' do
        expect { patch :rate, params: { id: votable, format: :json } }.to_not change(Vote, :count)
      end

      it 'does not changes answer rating' do
        patch :rate, params: { id: votable, rating: 1, format: :json }
        expect(assigns(:votable).rating).to eq(0)
      end

      it 'requestes with code 403' do
        patch :rate, params: { id: votable, format: :json }
        expect(response.status).to eq(403)
      end
    end

    context 'when user is not owner' do
      before { votable.update(user: some_user) }

      it 'updates answer votes count' do
        expect { patch :rate, params: { id: votable, rating: 1, format: :json } }.to change(votable.votes, :count).by(1)
      end

      it 'sets answer rating to be equal 1' do
        patch :rate, params: { id: votable, rating: 1, format: :json }
        expect(assigns(:votable).rating).to eq(1)
      end

      it 'sets answer rating to be equal -1' do
        patch :rate, params: { id: votable, rating: -1, format: :json }
        expect(assigns(:votable).rating).to eq(-1)
      end

      it 'responses with status code 200' do
        patch :rate, params: { id: votable, rating: -1, format: :json }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #unrate' do
    context 'when user is not vote owner' do
      it 'does not change vote count' do
        expect { delete :unrate, params: { id: votable, format: :json } }.to_not change(Vote, :count)
      end

      it 'responses with code 403' do
        delete :unrate, params: { id: votable, format: :json }
        expect(response.status).to eq(403)
      end
    end

    context 'when user is vote owner' do
      let!(:vote) { create(:vote, votable: votable, user: @user, rating: 1) }
      it 'removes users vote' do
        expect { delete :unrate, params: { id: votable, format: :json } }.to change(Vote, :count).by(-1)
      end

      it 'responses with code 200' do
        delete :unrate, params: { id: votable, format: :json }
        expect(response.status).to eq(200)
      end
    end
  end
end
