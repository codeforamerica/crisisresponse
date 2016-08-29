class DraftsController < ApplicationController
  def index
    @response_plans = ResponsePlan.drafts.where(author: current_officer)
  end
end
