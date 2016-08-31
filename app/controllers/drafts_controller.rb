class DraftsController < ApplicationController
  def index
    @drafts = ResponsePlan.drafts.where(author: current_officer)
  end

  def show
    @draft = ResponsePlan.find(params[:id])
  end
end
