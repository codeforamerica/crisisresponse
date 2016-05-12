class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def theme
    session[:theme] || :day
  end

  helper_method :theme

  def after_sign_out_path_for(*_args)
    new_officer_session_path
  end
end
