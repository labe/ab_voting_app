class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :validate_session!, except: [:index]
  after_action :clear_session!, only: [:create]

  def index
    @vote_counts_per_candidate = Vote.read_cached_votes
    @votes_counted_at = Vote.cached_votes_updated_at
  end

  def new
    if Vote.exists?(user: current_user)
      redirect_to :results, notice: 'Your vote has already been recorded.'
    end

    @candidates = Candidate.order('LOWER(name)')
    @can_write_in = @candidates.length < Candidate::MAX_CANDIDATES
    @expires_at = session[:expires_at]
  end

  def create
    candidate_id = params.require(:candidate_id)
    candidate =
      if candidate_id == 'other' && params.permit(:write_in)
        Candidate.create(name: params[:write_in])
      else
        Candidate.find(candidate_id)
      end

    Vote.create!(user: current_user, candidate: candidate)

    if Vote.count % Vote::CACHE_INCREMENT == 0
      Vote.write_cached_votes
    end

    redirect_to :results, notice: 'Your vote has been recorded.'
  end
end
