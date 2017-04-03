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
      #authenticate!
      new_file = ActionDispatch::Http::UploadedFile.new(params[:image])

      @word = Word.new
      @word.name = permitted_params[:name]
      @word.associate = permitted_params[:associate]
      @word.learned = permitted_params[:learned]
      @word.transcription = permitted_params[:transcription]
      @word.translation = permitted_params[:translation]
      @word.share = permitted_params[:share]
      @word.phrase = permitted_params[:phrase]
      #word.user = current_user
      @word.user = User.find_by_id(16) #- from controller
      #@word.user = current_user if current_user - from controller (commented)
      @word.theme = Theme.find_by_name('City')
      @word.image = new_file

      if @word.save
        status :ok
        @message = 'Success'
      else
        status :unprocessable_entity
        @message = @word.errors
      end
    end


  end

=begin

  def edit
    unless @word.user.eql?(current_user)
      redirect_to words_path
    end
  end

  def update
    respond_to do |format|
      if @word.update(word_params)
        msg = { message: 'Updated' }
        format.json { render json: msg, status: :ok}
      else
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @word.user.eql?(current_user)
      @word.destroy
      respond_to do |format|
        msg = { message: 'Deleted' }
        format.json { render json: msg, status: :ok }
      end
    else
      redirect_to root_path
    end
  end

  def wordscount
    message = Word.all.size.to_s
    render json: { count: message }
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name, :transcription, :translation, :associate, :phrase, :image, :share, :learned)
  end

=end

end
