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
        {
          message: 'Success',
          status: :created,
          token: create_token(@user)
        }
      else
        status :unprocessable_entity
        {
          message: @user.errors,
          status: :unprocessable_entity
        }
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
    post do
      @user = User.find_by_login(params[:login])
      if @user && @user.authenticate(params[:password])
        {
          message: 'Success',
          status: :ok,
          token: create_token(@user)
        }
      else
        status :unauthorized
        { message: 'Error', status: :unauthorized }
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
      email_found = User.exists?(email: params[:email])
      login_found = User.exists?(login: params[:login])
      (email_found || login_found) ? "true" : "false"
    end

    #/api/v1/users/show
    desc 'Show user`s data'
    get '/show' do
      authenticate!
      {
        name: current_user.name,
        login: current_user.login,
        email: current_user.email
      }
    end

  end

end
