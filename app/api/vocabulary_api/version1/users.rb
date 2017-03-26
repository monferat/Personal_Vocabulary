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
      user = User.new(params)

      if user.save
        status :created
        # todo: create token
        #log_in user
        { message: 'Success', status: :created }
      else
        status :unprocessable_entity
        { message: user.errors, status: :unprocessable_entity }
      end
    end

    ##############################################################



  end

end
