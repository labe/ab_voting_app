class VotesController < ApplicationController
  def index
    @vote_counts_per_candidate = Vote.read_cached_votes
    @votes_counted_at = Vote.cached_votes_updated_at
  end

  def new;end
end
