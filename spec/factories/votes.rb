FactoryBot.define do
  factory :vote do
    user { create(:user) }
    candidate { create(:candidate) }
  end
end
