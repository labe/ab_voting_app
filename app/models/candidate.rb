class Candidate < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  has_many :votes

  MAX_CANDIDATES = 10.freeze
end
