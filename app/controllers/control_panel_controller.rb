class ControlPanelController < ApplicationController

  http_basic_authenticate_with :name => ENV['CP_USER'], :password => ENV['CP_PASSWORD']

  def index_users
    @users = User.all
  end

  def index_themes
    @themes = Theme.all
  end

end
