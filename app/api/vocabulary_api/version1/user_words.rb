class VocabularyAPI::Version1::UserWords < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words
    desc 'Add new word to personal vocabulary'
    params do
      requires :name, type: String
      optional :transcription, type: String
      optional :translation, type: String
      optional :associate, type: String
      optional :phrase, type: String
      optional :share, type: Boolean, default: false
      optional :learned, type: Boolean, default: false
      requires :theme_name, type: String
      requires :image, type: Hash do
        requires :data, type: String
        requires :filename, type: String
      end
    end
    post '', jbuilder: 'response_message' do
      set_auth

      theme = Theme.find_by(name: permitted_params[:theme_name])
      @word = Word.find_or_create_by(name: permitted_params[:name], theme: theme)

      @user_word = UserWord.new(user_word_params)
      @user_word.word = @word
      @user_word.user = current_user

      image = Paperclip.io_adapters.for(permitted_params[:image][:data])
      image.original_filename = permitted_params[:image][:filename]
      @user_word.image = image if image

      if @user_word.save
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @user_word.errors
      end

    end


    #/api/v1/words/my
    desc 'Show all words of current user'
    params do
      optional :page, type: Integer
      optional :range, type: Integer
      optional :sort, type: String
    end
    get '/my', jbuilder: 'my_words' do
      set_auth

      page = params[:page]
      range = params[:range]
      sort_param = permitted_params[:sort]

      if sort_param == 'recent'
        words = @user.user_words.recent
      elsif sort_param == 'alphabetic'
        words = @user.user_words.includes(:word).order("words.name ASC")
      else
        words = @user.user_words
      end

      range = 100 unless range
      @user_words = page ? words[page*range..page*range-range] : words
    end

    #/api/v1/words/edit
    desc 'Edit user word'
    params do
      requires :name, type: String
      optional :transcription, type: String
      optional :translation, type: String
      optional :associate, type: String
      optional :phrase, type: String
      optional :share, type: Boolean
      optional :learned, type: Boolean
      optional :image, type: Rack::Multipart::UploadedFile
    end
    post '/edit', jbuilder: 'response_message' do
      authenticate!
      set_word
      if @user_word.update(user_word_params)
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @user_word.errors
      end
    end

    #api/v1/words/delete
    desc 'Delete user word'
    params do
      requires :name
    end
    delete '/delete', jbuilder: 'response_message' do
      set_word
      if @user_word.destroy
        status :ok
        @message = 'User word deleted'
      else
        status :unprocessable_entity
        @message = @user_word.errors
      end
    end

    #/api/v1/words/count/my
    desc 'Count shared words'
    get '/count/my', jbuilder: 'response_message' do
      set_auth
      @message = @user.user_words.size.to_s
    end

    #/api/v1/words/filter
    desc 'Filter words by shared(true or false), learn(true or false), category(theme_name)'
    params do
      requires :shared, type: Boolean
      requires :learn, type: Boolean
      requires :category, type: String
      optional :page, type: Integer
      optional :range, type: Integer
    end
    get '/filter', jbuilder: 'my_words' do
      page = params[:page]
      range = params[:range]
      set_auth
      words = @user.user_words.filter(permitted_params.slice(:shared, :learn, :category))
      @user_words = page ? words[page*range..page*range-range] : words
    end

    #/api/v1/words/check
    desc 'Check word'
    params do
      requires :word_name, type: String
    end
    get '/check', jbuilder: 'response_message' do
      word_name = params[:word_name].downcase
      @correct_words = checker
      @message = @correct_words[word_name] ? 'true' : 'false'
    end

    #/api/v1/words/search
    desc 'Search word'
    params do
      requires :text, type: String
      requires :lang, type: String
      optional :page, type: Integer
      optional :range, type: Integer
    end
    get '/search', jbuilder: 'my_words' do
      page = params[:page]
      range = params[:range]
      set_auth
      if params[:lang] == 'ru'
        words = @user.user_words.search_by_translation(params[:text])
      else
        words = @user.user_words.search_by_word(params[:text])
      end
      @user_words = page ? words[page*range..page*range-range] : words
    end

  end

  private

  helpers do
    include Checker

    def set_word
      word = Word.find_by(name: permitted_params[:name])
      @user_word = UserWord.find_by(word: word, user: current_user)
    end

    def user_word_params
      {transcription: permitted_params[:transcription],
      translation: permitted_params[:translation],
      associate: permitted_params[:associate],
      phrase: permitted_params[:phrase],
      share: permitted_params[:share],
      learned: permitted_params[:learned]}
    end

    def set_auth
      authenticate!
      @user = current_user if current_user
    end
  end

end
