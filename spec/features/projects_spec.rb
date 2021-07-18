require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  scenario 'user creates a new project' do
    user = FactoryBot.create(:user)

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect {
      click_link 'New Project'
      fill_in 'Name', with: 'Test Project'
      fill_in 'Description', with: 'Trying out Capybara'
      click_button 'Create Project'

      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    }.to change(user.projects, :count).by(1)
  end

  scenario 'user update a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: 'Test Project', owner: user)

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_link 'Test Project'
    visit "/projects/#{project.id}/edit"
    fill_in 'Name', with: 'New Project'
    click_button 'Update Project'

    expect(page).to have_content 'Project was successfully updated'
    expect(page).to have_content 'New Project'
    expect(project.reload.name).to eq 'New Project'
  end
end
