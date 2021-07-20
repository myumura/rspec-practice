require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a first name, last name, email, and password' do
    user = User.new(
      first_name: 'Aaron',
      last_name: 'Sumner',
      email: 'tester@example.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  subject(:user) { FactoryBot.build(:user) }
  it { is_expected.to satisfy { |user| user.name == 'Aaron Sumner' } }

  it 'does something with multiple users' do
    user1 = create(:user)
    user2 = create(:user)
    expect(true).to be_truthy
  end

  it 'can have some projects' do
    user = FactoryBot.build(:user, :with_projects)
    expect(user.projects.length).to eq 3
  end
end
