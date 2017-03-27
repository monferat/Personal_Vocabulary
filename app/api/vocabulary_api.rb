class VocabularyAPI < Grape::API

  prefix :api
  version 'v1'
  content_type :json, 'application/json; charset=UTF-8'
  format :json

  before do
    #allow CORS requests
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end
=begin
  helpers do
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end
  end
=end
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