class ThemesController < ApplicationController
  before_action :set_theme, only: [:edit, :update, :destroy]

  def themes
  end

  def edit
  end

  def update
  end

  def destroy
    @theme.destroy
    respond_to do |format|
      format.html { redirect_to admin_themes_path, notice: 'Theme was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def new
  end

  def create
    @theme = Theme.new(theme_params)
    @theme.save
    respond_to do |format|
      format.html { redirect_to admin_themes_path }
      format.js
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
