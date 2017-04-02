include Knock::Authenticable

class VocabularyAPI < Grape::API

  prefix :api
  version 'v1'
  content_type :json, 'application/json; charset=UTF-8'
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  before do
    #allow CORS requests
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'

    authenticate_for User
  end

  helpers do
    def authenticate!
      error!('Unauthorized') unless current_user
    end

    def create_token(user)
      Knock::AuthToken.new(payload: { sub: user.id }).token
    end
  end

  mount VocabularyAPI::Version1

  add_swagger_documentation(
      api_version: 'v1',
      hide_documentation_path: true,
      hide_format: true,
      info: {
          title: 'API documentation'
      }
  )

end
