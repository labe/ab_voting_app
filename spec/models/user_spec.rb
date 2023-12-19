require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'associations' do
    it { should have_one(:vote) }
  end

  describe 'validations' do
    context 'email' do
      it { should validate_uniqueness_of(:email).case_insensitive }

      [nil, '', 'one.com', 'hello'].each do |invalid_email|
        it {
          subject.email = invalid_email
          should be_invalid
        }
      end
    end

    context 'zip_code' do
      it { should be_valid }

      [nil, '', '1234', '123456', 'aa', '1234a'].each do |invalid_zip|
        it {
          subject.zip_code = invalid_zip
          should be_invalid
        }
      end
    end
  end
end
