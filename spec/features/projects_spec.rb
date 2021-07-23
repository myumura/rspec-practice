require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  let(:user) { create(:user) }

  scenario 'user creates a new project' do
    sign_in_as user

    expect do
      click_link 'New Project'
      fill_in_with('Name', 'Test Project')
      fill_in_with('Description', 'Trying out Capybara')
      click_button 'Create Project'
    end.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect_to_have_content('Project was successfully created')
      expect_to_have_content('Test Project')
      expect_to_have_content("Owner: #{user.name}")
    end
  end

  scenario 'user updates a project' do
    project = create(:project, name: 'Test Project', owner: user)
    sign_in user
    visit root_path

    click_link 'Test Project'
    visit "/projects/#{project.id}/edit"
    fill_in_with('Name', 'New Project')
    click_button 'Update Project'

    aggregate_failures do
      expect_to_have_content('Project was successfully updated')
      expect_to_have_content('New Project')
      expect(project.reload.name).to eq 'New Project'
    end
  end

  scenario 'user completes a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    sign_in user

    visit project_path(project)

    expect(page).to_not have_content 'Completed'

    click_button 'Complete'

    expect(project.reload.completed?).to be true
    expect(page).to have_content 'Congratulations, this project is complete!'
    expect(page).to have_content 'Completed'
    expect(page).to_not have_button 'Complete'
  end

  scenario 'dashbord shows only completed projects' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Incompleted Project', owner: user)
    FactoryBot.create(:project, :completed, owner: user)
    sign_in user

    visit root_path

    expect(page).to_not have_content 'Completed Project'
    expect(page).to have_content 'Incompleted Project'
  end

  def fill_in_with(label, content)
    fill_in label, with: content
  end

  def expect_to_have_content(content)
    expect(page).to have_content content
  end
end
