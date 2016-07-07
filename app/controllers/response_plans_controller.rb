require "csv"
require "net/http"
require "rms_adapter"

class ResponsePlansController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin, except: [:index, :show]

  def index
    @search = ResponsePlanSearch.new(search_params)
    @search.validate
    @response_plans = @search.close_matches

    unless current_officer.admin?
      @response_plans = @response_plans.select(&:approved?)
    end
  end

  def show
    @response_plan = ResponsePlan.find(params[:id])

    unless current_officer.admin?
      ensure_response_plan_is_approved(@response_plan)
    end
  end

  def new
    @response_plan = ResponsePlan.new
  end

  def create
    @response_plan = ResponsePlan.new(response_plan_params)
    @response_plan.author = current_officer

    if @response_plan.save
      redirect_to(
        response_plan_path(@response_plan),
        notice: t("response_plans.create.success", name: @response_plan.name),
      )
    else
      render :new
    end
  end

  def edit
    @response_plan = ResponsePlan.find(params[:id])
  end

  def update
    @response_plan = ResponsePlan.find(params[:id])
    @response_plan.update_attributes(response_plan_params)
    @response_plan.author = current_officer

    if @response_plan.save
      redirect_to(
        response_plan_path(@response_plan),
        notice: t("response_plans.update.success", name: @response_plan.name),
      )
    else
      render :edit
    end
  end

  def approve
    plan = ResponsePlan.find(params[:id])
    plan.approver = current_officer

    if plan.save
      redirect_to(
        response_plan_path(plan),
        notice: t("response_plans.approval.success", name: plan.name),
      )
    else
      redirect_to(
        response_plan_path(plan),
        alert: t("response_plans.approval.failure"),
      )
    end
  end

  private

  def search_params
    if params[:response_plan_search].present?
      params.require(:response_plan_search).permit(:name, :date_of_birth)
    else
      {}
    end
  end

  def response_plan_params
    params.require(:response_plan).permit(
      :first_name,
      :last_name,
      :date_of_birth,
      :weight_in_pounds,
      :height_in_inches,
      :eye_color,
      :hair_color,
      :scars_and_marks,
      :race,
      :sex,
      :background_info,
      :location_name,
      :location_address,
      :private_notes,
      images_attributes: [
        :source,
        :_destroy,
        :id,
      ],
      aliases_attributes: [
        :name,
        :_destroy,
        :id,
      ],
      contacts_attributes: [
        :name,
        :relationship,
        :cell,
        :notes,
        :_destroy,
        :id,
      ],
      response_strategies_attributes: [
        :title,
        :description,
        :_destroy,
        :id,
      ],
    )
  end

  def ensure_response_plan_is_approved(response_plan)
    unless response_plan.approved?
      raise ActiveRecord::RecordNotFound
    end
  end
end
