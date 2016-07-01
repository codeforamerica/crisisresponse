class PreferencesController < ApplicationController
  def create
    session[:theme] = inactive_theme
    redirect_to :back
  end
end
