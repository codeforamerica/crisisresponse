# frozen_string_literal: true

class ApplicationController < ActionController::Base
  REDIRECT_AFTER_SIGN_IN = :redirect_after_sign_in

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :theme, :officer_signed_in?, :current_officer, :demo_mode?

  def authenticate_officer!
    unless officer_signed_in?
      session[REDIRECT_AFTER_SIGN_IN] = request.fullpath

      redirect_to(
        new_authentication_path,
        alert: t("authentication.unauthenticated"),
      )
    end
  end

  def authorize_admin
    unless officer_signed_in? && current_officer.admin?
      redirect_to(
        people_path,
        alert: t("authentication.unauthorized.new_response_plan"),
      )
    end
  end

  def authorize_owner
    unless officer_signed_in? && current_officer.owner?
      redirect_to(
        people_path,
        alert: t("authentication.unauthorized.new_response_plan"),
      )
    end
  end

  def current_officer
    @current_officer ||=
      if demo_mode?
        Officer.find_by(role: Officer::OWNER)
      else
        Officer.find_by(id: session[:officer_id])
      end
  end

  def officer_signed_in?
    current_officer.present?
  end

  def theme
    session[:theme] || "day"
  end

  def demo_mode?
    ENV.fetch("DEMO_MODE") == "true"
  end

  private

  def redirect_after_sign_in_path
    session.fetch(REDIRECT_AFTER_SIGN_IN, people_path)
  end
end
