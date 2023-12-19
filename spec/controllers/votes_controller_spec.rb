require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'GET #index' do
    subject { get :index }
    context 'when not signed in' do
      it { should have_http_status(:success) }
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { session[:user_id] = user.id }

      it { should have_http_status(:success) }
    end

    it 'loads cached voting results' do
      expect(Vote).to receive(:read_cached_votes)
      subject
    end

    it 'loads the cached timestamp for when voting results were updated' do
      expect(Vote).to receive(:cached_votes_updated_at)
      subject
    end
  end

  describe 'GET #new' do
    subject { get :new }

    context 'when not signed in' do
      it {
        should redirect_to(:login)
        expect(flash[:alert]).to eq('You must be signed in to do that.')
      }
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { session[:user_id] = user.id }

      context 'and the user has already voted' do
        before { create(:vote, user: user) }

        it { should redirect_to(:results) }
        it 'sets a flash notice' do
          subject
          expect(flash[:notice]).to eq('Your vote has already been recorded.')
        end
      end

      context 'and the user has not yet voted' do
        context 'and the user session has expired' do
          before { session[:expires_at] = 1.minute.ago }
          it {
            should redirect_to(:login)
            expect(flash[:alert]).to eq('Your session expired. Sign in again to resume voting.')
          }
        end

        context 'and the user session has not expired' do
          before { session[:expires_at] = 1.minute.from_now }
          it { should have_http_status(:success) }
        end
      end
    end
  end

  describe 'POST #create' do
    let(:params) { {} }
    subject { post :create, params: params }

    context 'when not signed in' do
      it {
        should redirect_to(:login)
        expect(flash[:alert]).to eq('You must be signed in to do that.')
      }
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      let(:candidate) { create :candidate }
      before { session[:user_id] = user.id }

      context 'when voting for an existing candidate' do
        let(:params) do
          { candidate_id: candidate.id }
        end

        it 'creates a vote for that candidate and the current user' do
          expect { subject }.to change { Vote.count }.by(1)
          vote = Vote.last
          expect(vote.user).to eq(user)
          expect(vote.candidate).to eq(candidate)
        end

        it { should redirect_to(:results) }
        it 'clears the session and sets a flash notice' do
          expect(controller).to receive(:clear_session!)
          subject
          expect(flash[:notice]).to eq('Your vote has been recorded.')
        end
      end

      context 'when voting for a write-in candidate' do
        let(:candidate_name) { SecureRandom.hex }
        let(:params) do
          { candidate_id: 'other', write_in: candidate_name }
        end

        it 'creates a new candidate' do
          expect { subject }.to change { Candidate.count }.by(1)
        end

        it 'creates a vote for that candidate and the current user' do
          expect { subject }.to change { Vote.count }.by(1)
          vote = Vote.last
          expect(vote.user).to eq(user)
          expect(vote.candidate).to eq(Candidate.last)
        end

        it { should redirect_to(:results) }
        it 'clears the session and sets a flash notice' do
          expect(controller).to receive(:clear_session!)
          subject
          expect(flash[:notice]).to eq('Your vote has been recorded.')
        end
      end

      context 'when the new vote makes the total a factor of Vote::CACHE_INCREMENT' do
        let(:params) do
          { candidate_id: candidate.id }
        end
        before { expect(Vote).to receive(:count).and_return(Vote::CACHE_INCREMENT) }

        it 'updates the votes cache' do
          expect(Vote).to receive(:write_cached_votes).and_call_original
          subject
        end
      end
    end
  end
end
