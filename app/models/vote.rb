class Vote < ActiveRecord::Base
  validates :user_id, uniqueness: true

  belongs_to :user
  belongs_to :candidate

  CACHE_INCREMENT = 10.freeze

  def self.write_cached_votes
    results = Vote.joins(:candidate)
                  .group("candidates.name")
                  .count
                  .sort_by { |name, votes| [-votes, name.downcase] }
    Rails.cache.write('votes', results)
    Rails.cache.write('votes_updated_at', Time.current)
  end

  def self.read_cached_votes
    Rails.cache.read('votes')
  end

  def self.cached_votes_updated_at
    Rails.cache.read('votes_updated_at')
  end
end
