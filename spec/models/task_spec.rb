require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @project = FactoryBot.create(:project)
  end

  it 'is valid with a name and project' do
    task = Task.new(
      name: 'task',
      project: @project
    )
    expect(task).to be_valid
  end

  it 'is invalid without a name' do
    task = FactoryBot.build(:task, name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a project' do
    task = FactoryBot.build(:task, project: nil)
    task.valid?
    expect(task.errors[:project]).to include("can't be blank")
  end
end
