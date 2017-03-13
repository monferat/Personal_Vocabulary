class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_login(params[:login])
    if @user && @user.authenticate(params[:password])
      log_in @user
      respond_to do |format|
        format.html { redirect_to @user }
        msg = { message: 'Success' }
        format.json { render json: msg, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        msg = { message: 'error' }
        format.json { render json: msg, status: :unauthorized}
      end
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
