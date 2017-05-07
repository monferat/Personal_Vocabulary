class VocabularyAPI::Version1::UserWords < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words/new
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
      optional :image, type: Hash do
        optional :data, type: String
        optional :filename, type: String
      end
    end
    post '/new', jbuilder: 'response_message' do
      set_auth

      theme = Theme.find_by(name: permitted_params[:theme_name])
      @word = Word.find_or_create_by(name: permitted_params[:name], theme: theme)

      @user_word = UserWord.new(user_word_params)
      @user_word.word = @word
      @user_word.user = current_user

      if permitted_params[:image]
        image = Paperclip.io_adapters.for(permitted_params[:image][:data])
        image.original_filename = permitted_params[:image][:filename]
        @user_word.image = image if image
      end

      if unique
        if @user_word.save
          status :ok
          @message = "Success"
        else
          status :unprocessable_entity
          @message = @user_word.errors
        end
      else
        @message = 'duplicated word'
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
      paginate(page, range, words)
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
      optional :image, type: Hash do
        optional :data, type: String
        optional :filename, type: String
      end
    end
    post '/edit', jbuilder: 'response_message' do
      authenticate!
      set_word

      if permitted_params[:image]
        image = Paperclip.io_adapters.for(permitted_params[:image][:data])
        image.original_filename = permitted_params[:image][:filename]
        @user_word.image = image if image
      end

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
      set_auth
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
      paginate(page, range, words)
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
      paginate(page, range, words)
    end


    #/api/v1/words/notifier
    desc 'Words for the given date'
    params do
      requires :date, type: String
    end
    get '/notifier', jbuilder: 'my_words' do
      set_auth

      current_date = permitted_params[:date].to_date
      dates = [current_date.yesterday.beginning_of_day..current_date.end_of_day]
      dates.concat dates_for_period(current_date, 1.week)
      dates.concat dates_for_period(current_date, 1.month)
      dates.concat dates_for_period(current_date, 1.year)

      @user_words = UserWord.all.where(user: @user, learned: false, created_at: dates)
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

    def unique
      !@user.user_words.exists?(word: Word.find_by(name: permitted_params[:name]))
    end

    def paginate(page, range, words)
      @user_words = page ? words[page*range-range..page*range] : words
    end

    def dates_for_period(date, period)
      dates = []
      date -= period
      while date.end_of_day > @user.created_at
        dates.append(date.beginning_of_day..date.end_of_day)
        date -= period
      end
      dates
    end
  end

end
