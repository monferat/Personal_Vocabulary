class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: params[:session][:login])
    if user && user.authenticate(params[:session][:password])
      log_in user
      respond_to do |format|
        format.html { redirect_to user }
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
    log_out
    redirect_to root_url
  end
end
