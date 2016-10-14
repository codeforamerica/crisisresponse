class PreferencesController < ApplicationController
  def create
    session[:theme] = inactive_theme
    redirect_back(fallback_location: root_path)
  end

  private

  def inactive_theme
    toggle("day", "night", theme)
  end

  def toggle(first, second, current)
    {
      first => second,
      second => first,
      nil => second,
    }.with_indifferent_access[current]
  end
end
