class VocabularyAPI::Version1::Users < Grape::API

  resource :registration do

    #/api/v1/registration
    desc 'Create new user'
    params do
      requires :login, type: String
      requires :name, type: String
      requires :email, type: String
      requires :password, type: String
      requires :password_confirmation, type: String
    end
    post do
      @user = User.new(params)
      if @user.save
        status :created
        # todo: create token
        #       log_in user
        { message: 'Success', status: :created, token: @user.token }
      else
        status :unprocessable_entity
        { message: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  #############################################################

  #/api/v1/log_in
  resource :log_in do

    desc 'User log in'
    params do
      requires :login, type: String
      requires :password, type: String
    end
    post do
      #     authenticate!
      @user = User.find_by_login(params[:login])
      if @user && @user.authenticate(params[:password])
        # todo: find by token
        #       log_in @user
        { message: 'Success', status: :ok, token: @user.token }
      else
        status :unauthorized
        { message: 'Error', status: :unauthorized }
      end
    end

  end

  ##############################################################

  #/api/v1/users
  resource :users do

    #/api/v1/users/check
    desc 'Check if users with given parameters exists'
    params do
      requires :login, type: String
      requires :email, type: String
    end
    get '/check' do
      email_found = User.where(email: params[:email]).count > 0
      login_found = User.where(login: params[:login]).count > 0
      (email_found || login_found) ? "true" : "false"
    end

    ################################################################

    #/api/v1/users/:id
    desc 'Get user by id'
    get '/:id' do
      set_user
#      @user = current_user
      if @user == current_user
        {
          name: @user.name,
          login: @user.login,
          email: @user.email
        }
      else
        { message: 'Anauthorized access', status: :unauthorized }
      end
    end

  end

  private

  helpers do
    def set_user
      @user = User.find(params[:id])
    end
  end

end
