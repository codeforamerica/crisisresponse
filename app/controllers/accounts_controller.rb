# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_officer!

  def edit
  end

  def update
    if current_officer.update(update_params)
      redirect_to edit_account_path, notice: t(".success")
    else
      flash.now = t(".failure")
      render :edit
    end
  end

  private

  def update_params
    params.require(:officer).permit(:name, :unit, :title, :phone)
  end
end
