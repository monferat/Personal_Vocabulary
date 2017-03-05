class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    if current_user
      set_user
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:login, :name, :email, :password, :password_confirmation)
    end

end
