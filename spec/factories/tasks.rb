FactoryBot.define do
  factory :task do
    name 'New Task'
    association :project
  end
end
