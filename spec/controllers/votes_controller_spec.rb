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
end
