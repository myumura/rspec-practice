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

  it 'is invalid without a first name' do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    create(:user, email: 'aaron@example.com')
    user = FactoryBot.build(:user, email: 'aaron@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end

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
