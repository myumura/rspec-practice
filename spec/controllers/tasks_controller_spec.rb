require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context 'project setup'

  describe '#show' do
    it 'responds with JSON formatted output' do
      sign_in user
      get :show, format: :json, params: { project_id: project.id, id: task.id }
      expect(response).to have_content_type :json
    end
  end

  describe '#create' do
    it 'responds with JSON formatted output' do
      task_params = FactoryBot.attributes_for(:task)
      sign_in user
      post :create, format: :json, params: { project_id: project.id, task: task_params }
      expect(response).to have_content_type :json
    end

    it 'adds a new task to the project' do
      task_params = FactoryBot.attributes_for(:task)
      sign_in user
      expect {
        post :create, format: :json, params: { project_id: project.id, task: task_params }
      }.to change(project.tasks, :count).by(1)
    end

    it 'requires authentication' do
      task_params = FactoryBot.attributes_for(:task)
      expect {
        post :create, format: :json, params: { project_id: project.id, task: task_params }
      }.to_not change(project.tasks, :count)
      expect(response).to_not be_success
    end
  end
end
