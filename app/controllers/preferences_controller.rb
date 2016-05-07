class PreferencesController < ApplicationController
  def create
    session[:theme] = toggle(:day, :night, session[:theme])
    redirect_to :back
  end

  private

  def toggle(first, second, current)
    {
      first => second,
      second => first,
      nil => second,
    }.with_indifferent_access[current]
  end
end
