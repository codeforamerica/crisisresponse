require "csv"
require "net/http"
require "rms_adapter"

class ResponsePlansController < ApplicationController
  before_action :authenticate_officer!

  def index
    @search = ResponsePlanSearch.new(search_params)
    @search.validate
    @response_plans = @search.close_matches
  end

  def show
    @response_plan = ResponsePlan.find(params[:id])
    ensure_response_plan_is_approved(@response_plan)
  end

  private

  def search_params
    if params[:response_plan_search].present?
      params.require(:response_plan_search).permit(:name, :date_of_birth)
    else
      {}
    end
  end

  def ensure_response_plan_is_approved(response_plan)
    unless response_plan.approved?
      raise ActiveRecord::RecordNotFound
    end
  end
end
