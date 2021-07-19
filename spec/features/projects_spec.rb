require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  scenario 'user creates a new project' do
    sign_in_as user

    expect {
      click_link 'New Project'
      fill_in_with('Name', 'Test Project')
      fill_in_with('Description', 'Trying out Capybara')
      click_button 'Create Project'
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect_to_have_content('Project was successfully created')
      expect_to_have_content('Test Project')
      expect_to_have_content("Owner: #{user.name}")
    end
  end

  scenario 'user updates a project' do
    project = FactoryBot.create(:project, name: 'Test Project', owner: user)
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

  def fill_in_with(label, content)
    fill_in label, with: content
  end

  def expect_to_have_content(content)
    expect(page).to have_content content
  end
end
