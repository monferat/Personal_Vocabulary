class UsersController < ApplicationController
=begin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #/api/v1/users/:id
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
=end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

=begin
  def new
    @user = User.new
  end

  # post /api/v1/registration
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user }
        msg = { message: 'Success' }
        format.json { render json: msg, status: :created}
      else
        format.html { render 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # get /api/v1/users/check?login=login&email=email%40domain.com
  def check
    email_found = User.where(email: params[:email]).count > 0
    login_found = User.where(login: params[:login]).count > 0
    message = (email_found || login_found) ? "true" : "false"
    render json: { message: message }
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:login, :name, :email, :password, :password_confirmation)
    end
=end

end
