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
    post '', jbuilder: 'response_message' do
      @user = User.new(permitted_params)
      if @user.save
        status :created
        @message = 'Success'
        @token = create_token(@user)
      else
        status :unprocessable_entity
        @message = @user.errors
      end
    end

  end

  #/api/v1/log_in
  resource :log_in do

    desc 'User log in'
    params do
      requires :login, type: String
      requires :password, type: String
    end
    post '', jbuilder: 'response_message' do
      @user = User.find_by(login: permitted_params[:login])
      if @user && @user.authenticate(permitted_params[:password])
        status :ok
        @message = 'Success'
      else
        status :unauthorized
        @message = 'Wrong login or password'
      end
    end

  end

  #/api/v1/users
  resource :users do

    #/api/v1/users/check
    desc 'Check if users with given parameters exists'
    params do
      requires :login, type: String
      requires :email, type: String
    end
    get '/check' do
      email_found = User.exists?(email: permitted_params[:email])
      login_found = User.exists?(login: permitted_params[:login])
      (email_found || login_found) ? "true" : "false"
    end

    #/api/v1/users/show
    desc 'Show user`s data'
    get '/show', jbuilder: 'user' do
      authenticate!
      status :ok
    end

    #/api/v1/users/edit
    desc 'Edit user'
    params do
      optional :login, type: String
      optional :name, type: String
      optional :email, type: String
      optional :password, type: String
      optional :password_confirmation, type: String
    end
    put '/edit', jbuilder: 'response_message' do
      authenticate!
      if current_user.update(permitted_params)
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = current_user.errors
      end
    end

  end

end
