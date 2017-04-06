class VocabularyAPI::Version1::Words < Grape::API

  #/api/v1/words
  resources :words do

    #/api/v1/words
    desc 'Show all words from vocabulary'
    params do
      optional :page, type: Integer
    end
    get '', jbuilder: 'all_words' do
      #page = permitted_params[:page]
      #if page
       # @words = Word.all[0..page.to_i]
      #else
      @words = Word.all
      #end
    end

    #/api/v1/words/new
    desc 'Add new word to personal vocabulary'
    params do
      requires :name, type: String
      requires :transcription, type: String
      requires :translation, type: String
      requires :associate, type: String
      requires :phrase, type: String
      requires :share, type: String
      requires :learned, type: Boolean
      optional :theme_name, type: String
      optional :image, type: Rack::Multipart::UploadedFile
    end
    post '/new', jbuilder: 'response_message' do
      authenticate!
      @word = Word.new(permitted_params)
      @word.user = current_user
      @word.theme = Theme.find_by(name: params[:name])
      @word.image = ActionDispatch::Http::UploadedFile.new(params[:image])

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
      @word = Word.find(permitted_params)
    end
  end

end
