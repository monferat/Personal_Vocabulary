class VocabularyAPI::Version1::Users < Grape::API

  #/api/v1/users
  resource :users do

    #/api/v1/users/registration

    desc 'Create new user'

    params do
      requires :login, type: String
      requires :name, type: String
      requires :email, type: String
      requires :password, type: String
      requires :password_confirmation, type: String
    end

    post '/registration' do
      @user = User.new(params)

      if @user.save
        status :created
        # todo: create token
#        log_in user
        { message: 'Success', status: :created }
      else
        status :unprocessable_entity
        { message: @user.errors, status: :unprocessable_entity }
      end
    end

    ################################################################

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

    ##############################################################

    #/api/v1/users/:id
=begin
    desc 'Show users`s page by id'

    params do
      requires :id, type: Integer
    end

    get '/:id' do
      if current_user
        set_user
      else
        status :unauthorized
        { message: 'Unauthorized access', status: :unauthorized }
      end
    end
=end
  end

  private

  helpers do
    def set_user
      @user = User.find(params[:id])
    end
  end

end
