class VocabularyAPI < Grape::API

  prefix :api
  version 'v1'
  format :json

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
