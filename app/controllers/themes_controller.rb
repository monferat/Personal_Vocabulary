class ThemesController < ApplicationController
  before_action :set_theme, only: [:edit, :update, :destroy]

  def index
  end

  def edit
  end

  def update
  end

  def destroy
    @theme.destroy
    respond_to do |format|
      format.html { redirect_to admin_url, notice: 'Theme was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)
      if @theme.save
        format.html { redirect_to admin_url }
      else
        format.html { render 'new' }
      end
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:name)
  end
end
