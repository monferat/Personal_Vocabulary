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
      optional :share, type: Boolean
      optional :learned, type: Boolean
      requires :theme_name, type: String
      optional :image, type: Rack::Multipart::UploadedFile
    end
    post '/new', jbuilder: 'response_message' do
      authenticate!

      word = permitted_params[:name]
      theme = Theme.find_by(name: permitted_params[:theme_name])

      # need to be resolved by new migrations:
      # if the word is new, theme won't change!!
      @word = Word.exists?(name: word) ? Word.find_by(name: word) : Word.new(name: word, theme: theme)

      @user_word = UserWord.new(user_word_params)
      @user_word.word = @word
      @user_word.user = current_user

      image = permitted_params[:image]
      @user_word.image = ActionDispatch::Http::UploadedFile.new(image) if image

      if @word.save
        if @user_word.save
          status :ok
          @message = 'Success'
        else
          status :unprocessable_entity
          @message = @user_word.errors
        end
      else
        status :unprocessable_entity
        @message = @word.errors
      end
    end

    #/api/v1/words/my
    desc 'Show all words of current user'
    params do
      optional :page, type: Integer
    end
    get '/my', jbuilder: 'my_words' do
      authenticate!

      page = permitted_params[:page]
      user_words = UserWord.all.where(user: current_user)
      @user_words = page ? user_words[0..page] : user_words
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

    #/api/v1/words/unique
    desc 'Check if user word is already exist in user vocabulary'
    params do
      requires :word, type: String
    end
    get '/unique', jbuilder: 'response_message' do
      authenticate!
      @message = UserWord.exists?(word: Word.find_by(name: permitted_params[:word]),
                                  user: current_user).to_s
    end

  end

  private

  helpers do
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
  end

end
