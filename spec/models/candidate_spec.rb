require 'rails_helper'

RSpec.describe Candidate, type: :model do
  subject { build(:candidate) }

  describe 'associations' do
    it { should have_many(:votes) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe '::MAX_CANDIDATES' do
    it 'should be 10' do
      expect(Candidate::MAX_CANDIDATES).to eq(10)
    end
  end
end
