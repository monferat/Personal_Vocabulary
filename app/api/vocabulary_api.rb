class VocabularyAPI < Grape::API

  prefix :api
  version 'v1'
  format :json

  mount VocabularyAPI::Version1

end
