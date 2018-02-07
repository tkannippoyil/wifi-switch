shared_examples 'a RESTful controller' do |model_key, supported_actions = []|
  let(:model) { FactoryGirl.create(model_key) }

  # 'index' action
  if supported_actions.include? :index
    describe 'GET #index' do
      context 'when not logged in and authenticated' do
        before :each do
          get :index, format: :json
        end
        it { should respond_with 401 }
      end
      context 'when authenticated' do
        before :each do
          sign_in
        end
        context 'when authorised' do
          before :each do
            controller.current_user.add_role(FactoryGirl.create(:role_definition, :admin))
            get :index, format: :json
          end
          it { should respond_with 200 }
        end
        context 'when unauthorised (insufficient privileges)' do
          before :each do
            get :index, format: :json
          end
          it { should respond_with 403 }
        end
      end
    end
  end

  # 'show' action
  if supported_actions.include? :show
    describe 'GET #show' do
      context 'when not logged in and authenticated' do
        before :each do
          get :show, id: model.id, format: :json
        end
        it { should respond_with 401 }
      end
      context 'when authenticated' do
        before :each do 
          sign_in
        end
        context 'when authorised' do
          before :each do
            controller.current_user.add_role(FactoryGirl.create(:role_definition, :admin))
          end
          context 'when requested record exists' do
            before :each do
              get :show, id: model.id, format: :json 
            end
            it { should respond_with 200 }
            it 'returns HTTP 406 (Not Acceptable) when too few parameters are supplied'
            it 'returns HTTP 406 (Not Acceptable) when parameters have incorrect types'
          end
          context 'when requested record does not exist' do
            before :each do
              get :show, id: 'invalid', format: :json 
            end
            it { should respond_with 404 }
          end
        end
        context 'when unauthorised (insufficient privileges)' do
          before :each do 
            get :show, id: model.id, format: :json 
          end
          it { should respond_with 403 }
        end
      end
    end
  end

  # 'create' action
  if supported_actions.include? :create
    describe 'POST #create' do
      context 'when not logged in and authenticated' do
        before :each do
          post :create, "#{model_key}" => attributes_for(model_key), :format => :json
        end
        it { should respond_with 401 }
      end
      context 'when authenticated' do
        before :each do
          sign_in
        end
        context 'when authorised' do
          before :each do
            controller.current_user.add_role(FactoryGirl.create(:role_definition, :admin))
            post :create, "#{model_key}" => attributes_for(model_key), :format => :json
          end
          it { should respond_with 201 }
          it 'returns HTTP 406 (Not Acceptable) when too few parameters are supplied'
          it 'returns HTTP 406 (Not Acceptable) when parameters have incorrect types'
        end
        context 'when unauthorised (insufficient privileges)' do
          before :each do
            post :create, "#{model_key}" => attributes_for(model_key), :format => :json
          end
          it { should respond_with 403 }
        end
      end
    end
  end

  # 'update' action
  if supported_actions.include? :update
    describe 'PUT #update' do
      context 'when not logged in and authenticated' do
        before :each do
          put :update, id: model.id, "#{model_key}" => attributes_for(model_key), :format => :json
        end
        it { should respond_with 401 }
      end
      context 'when authenticated' do
        before :each do
          sign_in
        end
        context 'when authorised' do
          before :each do
            controller.current_user.add_role(FactoryGirl.create(:role_definition, :admin))
          end
          context 'when requested record exists' do
            before :each do
              put :update, id: model.id, "#{model_key}" => attributes_for(model_key), :format => :json
            end
            it { should respond_with 200 }
            it 'returns HTTP 406 (Not Acceptable) when too few parameters are supplied'
            it 'returns HTTP 406 (Not Acceptable) when parameters have incorrect types'
          end
          context 'when requested record does not exist' do
            before :each do
              put :update, id: 'invalid', format: :json 
            end
            it { should respond_with 404 }
          end
        end
        context 'when unauthorised (insufficient privileges)' do
          before :each do
            put :update, id: model.id, "#{model_key}" => attributes_for(model_key), :format => :json
          end
          it { should respond_with 403 }
        end
      end
    end
  end

  # 'destroy' action
  if supported_actions.include? :destroy
    describe 'DELETE #destroy' do
      context 'when not logged in and authenticated' do
        before :each do
          delete :destroy, id: model.id, format: :json
        end
        it { should respond_with 401 }
      end
      context 'when authenticated' do
        before :each do
          sign_in
        end
        context 'when authorised' do
          before :each do
            controller.current_user.add_role(FactoryGirl.create(:role_definition, :admin))
          end
          context 'when requested record exists' do
            before :each do
              delete :destroy, id: model.id, format: :json
            end
            it { should respond_with 200 }
            it 'returns HTTP 406 (Not Acceptable) when too few parameters are supplied'
            it 'returns HTTP 406 (Not Acceptable) when parameters have incorrect types'
          end
          context 'when requested record does not exist' do
            before :each do
              delete :destroy, id: 'invalid', format: :json
            end
            it { should respond_with 404 }
          end
        end
        context 'when unauthorised (insufficient privileges)' do
          before :each do
            delete :destroy, id: model.id, format: :json
          end
          it { should respond_with 403 }
        end
      end
    end
  end

end

