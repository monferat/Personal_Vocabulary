class VocabularyAPI::Version1::UserWords < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words/my
    desc 'Show all words of current user'
    params do
      optional :page
    end
    get '/my', jbuilder: 'all_words' do
      authenticate!
      @words = UserWord.all.where(user_id: current_user.id)
    end

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
      @word = Word.new(name: permitted_params[:name])
      @word.theme = Theme.find_by(name: permitted_params[:theme_name])

      @user_word = UserWord.new(transcription: permitted_params[:transcription],
                                translation: permitted_params[:translation],
                                associate: permitted_params[:associate],
                                phrase: permitted_params[:phrase],
                                share: permitted_params[:share],
                                learned: permitted_params[:learned])
      @user_word.word = @word
      @user_word.user = current_user
      @user_word.image = ActionDispatch::Http::UploadedFile.new(permitted_params[:image])

      if @word.save && @user_word.save
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @word.errors
      end
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
      optional :theme_name, type: String
      optional :image, type: Rack::Multipart::UploadedFile
    end
    post '/edit', jbuilder: 'response_message' do
      authenticate!
      set_word
      if @word.update(permitted_params)
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @word.errors
      end
    end

    #api/v1/words/delete
    desc 'Delete word'
    params do
      requires :name
    end
    delete '/delete', jbuilder: 'response_message' do
      set_word
      if @word.destroy
        status :ok
        @message = 'Word deleted'
      else
        status :unprocessable_entity
        @message = @word.errors
      end
    end

    #/api/v1/words/count
    desc 'Count all words'
    get '/count', jbuilder: 'response_message' do
      @message = Word.all.size.to_s
    end

  end

  private

  helpers do
    def set_word
      @word = Word.find_by(name: permitted_params[:name])
    end
  end

end
