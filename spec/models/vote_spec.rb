require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { build(:vote) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:candidate) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).case_insensitive }
  end

  describe '.write_cached_votes' do
    subject { Vote.write_cached_votes }
    let(:query) { Vote.all }
    let(:results) { {'GG': 8} }

    it 'writes the results to the cache' do
      expect(Vote).to receive(:joins).and_return(query)
      expect(query).to receive(:group).and_return(query)
      expect(query).to receive(:count).and_return(query)
      expect(query).to receive(:sort_by).and_return(results)
      expect(Rails.cache).to receive(:write).with('votes', results)
      allow(Rails.cache).to receive(:write).with('votes_updated_at', anything)
      subject
    end

    it 'writes the current time to the cache' do
      freeze_time do
        allow(Rails.cache).to receive(:write).with('votes', anything)
        expect(Rails.cache).to receive(:write).with('votes_updated_at', Time.current)
        subject
      end
    end
  end

  describe '.read_cached_votes' do
    subject { Vote.read_cached_votes }

    it 'reads the cache with a votes key' do
      expect(Rails.cache).to receive(:read).with('votes')
      subject
    end
  end

  describe '.cached_votes_updated_at' do
    subject { Vote.cached_votes_updated_at }

    it 'reads the cache with a votes key' do
      expect(Rails.cache).to receive(:read).with('votes_updated_at')
      subject
    end
  end

  describe '::CACHE_INCREMENT' do
    it 'should be 10' do
      expect(Vote::CACHE_INCREMENT).to eq(10)
    end
  end
end
