class WordsController < ApplicationController

  before_action :set_word, only: [:show, :edit, :update, :destroy]

  def index
    @words = Word.all
  end

  def show
  end

  def new
    if current_user
      @word = Word.new
    else
      redirect_to words_path
    end
  end

  def edit
    unless @word.user.eql?(current_user)
      redirect_to words_path
    end
  end

  def create
    @word = Word.new(word_params)
    @word.user = User.find_by_id(params[:user_id])
    #@word.user = current_user if current_user
    @word.theme_id = params[:theme_id]

    respond_to do |format|
      if @word.save
        msg = { message: 'Success' }
        format.json { render json: msg, status: :created}
      else
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
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

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:name, :transcription, :translation, :associate, :phrase, :url, :share, :learned)
  end


end
