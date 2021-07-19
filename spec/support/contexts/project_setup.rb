RSpec.shared_context 'project setup' do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }
  let(:task) { project.tasks.create!(name: 'Test task') }
end
