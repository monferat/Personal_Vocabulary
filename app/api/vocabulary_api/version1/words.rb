class VocabularyAPI::Version1::Words < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words/my
    desc 'Show all words of current user'
    params do
      optional :page
    end
    get '/my', jbuilder: 'all_words' do
      authenticate!
      @words = Word.all.where(user_id: current_user.id)
    end

    #/api/v1/words/shared
    desc 'Show all words from vocabulary'
    params do
      optional :page, type: Integer
    end
    get '/shared', jbuilder: 'all_words' do
      page = permitted_params[:page]
      if page
        @words = Word.all.where(share: true)[0..page]
      else
        @words = Word.all.where(share: true)
      end
    end

    #/api/v1/words/new
    desc 'Add new word to personal vocabulary'
    params do
      requires :word, type: Hash do
        requires :name, type: String
        requires :transcription, type: String
        requires :translation, type: String
        requires :associate, type: String
        requires :phrase, type: String
        requires :share, type: String
        requires :learned, type: Boolean
      end
      requires :theme_name, type: String
      optional :image, type: Rack::Multipart::UploadedFile
    end
    post '/new', jbuilder: 'response_message' do
      authenticate!

      @word = Word.new(permitted_params[:word])
      @word.theme = Theme.find_by(name: permitted_params[:theme_name])
      @word.user_id = current_user.id
      @word.image = ActionDispatch::Http::UploadedFile.new(permitted_params[:image])

      if @word.save
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @word.errors
      end
    end

    #/api/v1/words/edit
    desc 'Edit word'
    params do
      requires :name, type: String
      optional :transcription, type: String
      optional :translation, type: String
      optional :associate, type: String
      optional :phrase, type: String
      optional :share, type: String
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
