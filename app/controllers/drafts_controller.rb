class DraftsController < ApplicationController
  def index
    @response_plans = ResponsePlan.drafts.where(author: current_officer)
  end

  def show
    @response_plan = ResponsePlan.find(params[:id])
    @person = @response_plan.person
  end
end
