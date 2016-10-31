# frozen_string_literal: true

class OfficersController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_owner

  def index
    @privileged_officers = Officer.where(role: [Officer::ADMIN, Officer::OWNER])

    @officer_search = OfficerSearch.new search_params.merge(
      candidates: Officer.where(role: Officer::NORMAL),
    )
  end

  def edit
    @officer = Officer.find(params[:id])
  end

  def update
    @officer = Officer.find(params[:id])

    if @officer.update(update_params)
      redirect_to(
        edit_officer_path(@officer),
        notice: t(".success", name: @officer.name),
      )
    else
      flash.now[:error] = t(".failure", name: @officer.name)
      render :edit
    end
  end

  private

  def search_params
    params.require(:officer_search).permit(:name)
  rescue ActionController::ParameterMissing
    {}
  end

  def update_params
    params.require(:officer).permit(:name, :unit, :title, :phone, :role)
  end
end
