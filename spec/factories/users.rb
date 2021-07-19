FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name 'Aaron'
    last_name 'Sumner'
    sequence(:email) { |n| "tester#{n}@example.com" }
    password 'password'

    trait :with_projects do
      after(:build) { |user| create_list(:project, 3, owner: user) }
    end
  end
end
