require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joetester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze'
    )
    @project = @user.projects.create(
      name: 'Test Project'
    )
  end

  it 'is valid with a name and project' do
    task = Task.new(
      name: 'task',
      project: @project
    )
    expect(task).to be_valid
  end

  it 'is invalid without a name' do
    task = Task.new(name: nil)
    task.valid?
    expect(task.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a project' do
    task = Task.new(project: nil)
    task.valid?
    expect(task.errors[:project]).to include("can't be blank")
  end
end
