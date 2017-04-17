class VocabularyAPI::Version1::Words < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words/shared
    desc 'Show all shared words'
    params do
      optional :page, type: Integer
    end
    get '/shared', jbuilder: 'all_words' do
      page = permitted_params[:page]
      user_words = UserWord.all.where(share: true)
      @user_words = page ? user_words[0..page] : user_words
    end

    #/api/v1/words/count
    desc 'Count all words'
    get '/count', jbuilder: 'response_message' do
      @message = Word.all.size.to_s
    end

  end

end
