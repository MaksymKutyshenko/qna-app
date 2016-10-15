require 'rails_helper'

RSpec.describe 'Votable' do 

  with_model :WithVotable do 
    table do |t|
      t.belongs_to :user
    end
 
    model do 
      include Votable
      belongs_to :user
    end    
  end

  let!(:votable_owner) { create(:user) }
  let!(:voter1) { create(:user) }
  let!(:voter2) { create(:user) }
  let!(:votable) { WithVotable.create(user: votable_owner) }

  describe '#rate' do 
    it 'increase votable rating' do 
      votable.rate(voter1, 1)
      expect(votable.rating).to eq(1)
    end      

    it 'decrease votable rating' do 
      votable.rate(voter1, -1)
      expect(votable.rating).to eq(-1)
    end    
  end

  describe '#unrate' do 
    before { votable.rate(voter1, 1) }

    context 'when user is vote owner' do 
      before { votable.unrate(voter1) }

      it 'removes votable rating' do         
        expect(votable.rating).to eq(0)
      end

      it 'removes vote from db' do 
        expect(votable.votes.count).to eq(0)
      end
    end

    context 'when user is not vote owner' do 
      it 'does not remove votable rating' do
        votable.unrate(voter2)  
        expect(votable.rating).to eq(1)        
      end
    end
  end

  describe '#rating' do 
    it 'counts votable rating' do 
      votable.rate(voter1, 1)
      votable.rate(voter2, 1)
      expect(votable.rating).to eq(2)
    end
  end
end