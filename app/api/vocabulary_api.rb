class VocabularyAPI < Grape::API

  prefix :api
  version 'v1'
  content_type :json, 'application/json; charset=UTF-8'
  format :json

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
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
