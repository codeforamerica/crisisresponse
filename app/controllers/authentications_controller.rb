class AuthenticationsController < ApplicationController
  def new
    render locals: { sign_in: Authentication.new }
  end

  def create
    authentication = Authentication.new(authentication_params)

    if authentication.attempt_sign_on
      officer = Officer.find_or_create_by(authentication.officer_information)
      session[:officer_id] = officer.id
      redirect_to(
        people_path,
        notice: t("authentication.sign_in.success", name: officer.name),
      )
    else
      redirect_to(
        new_authentication_path,
        alert: t("authentication.sign_in.failure"),
      )
    end
  end

  def destroy
    session[:officer_id] = nil
    redirect_to(
      new_authentication_path,
      notice: t("authentication.sign_out.success"),
    )
  end

  private

  def authentication_params
    params.require(:authentication).permit(:username, :password)
  end
end
