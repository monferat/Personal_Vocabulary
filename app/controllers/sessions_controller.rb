class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_login(params[:login])
    if @user && @user.authenticate(params[:password])
      log_in @user
      respond_to do |format|
        format.html { redirect_to @user }
        msg = { status: 'ok', message: 'Success' }
        format.json { render json: msg }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        msg = { status: :unauthorized, message: 'error' }
        format.json { render json: msg }
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
