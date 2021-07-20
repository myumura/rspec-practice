require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = create(:user)
    @project = create(:project, name: 'Test Project', owner: @user)
  end

  it 'is valid with a name and description' do
    project = Project.new(
      name: 'project',
      description: 'hogehoge',
      owner: @user
    )
    expect(project).to be_valid
  end

  it 'is invalid without a name' do
    project = FactoryBot.build(:project, name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe 'late status' do
    it 'is late when the due date is past today' do
      project = create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = create(:project, :due_today)
      expect(project).to_not be_late
    end

    it 'is on time when the due date is in the future' do
      project = create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it 'can have many notes' do
    project = create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
