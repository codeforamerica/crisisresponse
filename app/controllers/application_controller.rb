class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :theme, :officer_signed_in?, :current_officer

  def authenticate_officer!
    unless officer_signed_in?
      redirect_to(
        new_authentication_path,
        alert: t("authentication.unauthenticated"),
      )
    end
  end

  def current_officer
    Officer.find_by(id: session[:officer_id])
  end

  def officer_signed_in?
    current_officer.present?
  end

  def theme
    session[:theme] || :day
  end
end
