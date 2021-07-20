require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end

      it 'responds successfully' do
        sign_in @user
        get :index
        aggregate_failures do
          expect(response).to be_success
          expect(response).to have_http_status '200'
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      let(:user) { double('user') }
      let(:project) { instance_double('Project', owner: user, id: '123') }

      before do
        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)
        allow(Project).to receive(:find).with('123').and_return(project)
      end

      it 'responds successfully' do
        get :show, params: { id: project.id }
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @project = create(:project, owner: other_user)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#new' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
      end

      it 'responds successfully' do
        sign_in @user
        get :new
        expect(response).to be_success
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        get :new
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        get :new
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#edit' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @project = create(:project, owner: @user)
      end

      it 'responds successfully' do
        sign_in @user
        get :edit, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @project = create(:project, owner: other_user)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        get :edit, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = create(:user)
      end

      context 'with valid attributes' do
        it 'adds a project' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect do
            post :create, params: { project: project_params }
          end.to change(@user.projects, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a project' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect do
            post :create, params: { project: project_params }
          end.to_not change(@user.projects, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @project = create(:project, owner: @user)
      end

      it 'updates a project' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'New Project Name'
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @project = create(:project, owner: other_user, name: 'Same Old Name')
      end

      it 'does not update the project' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'Same Old Name'
      end

      it 'redirects to the dashboard' do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        @project = create(:project)
      end

      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @project = create(:project, owner: @user)
      end

      it 'deletes a project' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to change(@user.projects, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @project = create(:project, owner: other_user)
      end

      it 'does not delete the project' do
        sign_in @user
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        @project = create(:project)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status '302'
      end

      it 'does not delete the project' do
        expect do
          delete :destroy, params: { id: @project.id }
        end.to_not change(Project, :count)
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
