class VocabularyAPI::Version1::Words < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words/shared
    desc 'Show all shared words'
    params do
      optional :page, type: Integer
      optional :range, type: Integer
    end
    get '/shared', jbuilder: 'all_words' do
      page = permitted_params[:page]
      words = UserWord.all.where(share: true)

      range = 100 unless range
      paginate(page, range, words)
      # @user_words = page ? user_words[0..page] : user_words
    end

    #/api/v1/words/count/all
    desc 'Count all words'
    get '/count/all', jbuilder: 'response_message' do
      @message = Word.all.size.to_s
    end

    #/api/v1/words/count/shared
    desc 'Count shared words'
    get '/count/shared', jbuilder: 'response_message' do
      @message = UserWord.all.where(share: true).size.to_s
    end

  end

  private
  helpers do
    def paginate(page, range, words)
      @user_words = page ? words[page*range-range..page*range] : words
    end
  end

end
