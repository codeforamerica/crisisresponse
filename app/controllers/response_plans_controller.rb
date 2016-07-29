require "csv"
require "net/http"
require "rms_adapter"

class ResponsePlansController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin, except: [:index, :show]

  def index
    @search = Search.new(search_params)
    @search.validate

    people = @search.close_matches
    @response_plans = people.map(&:active_response_plan).compact

    if current_officer.admin?
      @response_plans = people.map {|p| p.response_plans.order(:approved_at).last }
    end
  end

  def show
    @response_plan = ResponsePlan.find(params[:id])

    unless current_officer.admin?
      ensure_response_plan_is_approved(@response_plan)
    end
  end

  def new
    @response_plan = ResponsePlan.new(person: Person.new)
  end

  def create
    id = response_plan_params[:person_attributes][:id]
    person = id ? Person.find(id) : nil

    @response_plan = ResponsePlan.new(person: person, author: current_officer)
    @response_plan.assign_attributes(response_plan_params)

    if @response_plan.valid?
      @response_plan.person.save && @response_plan.save
      redirect_to(
        response_plan_path(@response_plan),
        notice: t("response_plans.create.success", name: @response_plan.person.name),
      )
    else
      render :new
    end
  end

  def edit
    original = ResponsePlan.find(params[:id])

    @response_plan = original.deep_clone(
      include: [
        :contacts,
        :deescalation_techniques,
        :response_strategies,
        :safety_concerns,
      ]
    )
  end

  def update
    @response_plan = ResponsePlan.find(params[:id])
    @response_plan.update_attributes(response_plan_params)
    @response_plan.author = current_officer

    if @response_plan.save
      redirect_to(
        response_plan_path(@response_plan),
        notice: t("response_plans.update.success", name: @response_plan.person.name),
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
        notice: t("response_plans.approval.success", name: plan.person.name),
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
    if params[:search].present?
      params.require(:search).permit(
        :name,
        :date_of_birth,
        :age,
        :height,
        :weight,
        eye_color: [],
        hair_color: [],
        race: [],
        sex: [],
      )
    else
      {}
    end
  end

  def response_plan_params
    params.require(:response_plan).permit(
      :background_info,
      :private_notes,
      contacts_attributes: [
        :_destroy,
        :cell,
        :id,
        :name,
        :notes,
        :organization,
        :relationship,
      ],
      deescalation_techniques_attributes: [
        :_destroy,
        :id,
        :description,
      ],
      person_attributes: [
        :date_of_birth,
        :eye_color,
        :first_name,
        :hair_color,
        :height_in_inches,
        :id,
        :last_name,
        :location_address,
        :location_name,
        :race,
        :scars_and_marks,
        :sex,
        :weight_in_pounds,
        aliases_attributes: [
          :_destroy,
          :id,
          :name,
        ],
        images_attributes: [
          :_destroy,
          :id,
          :source,
        ],
      ],
      response_strategies_attributes: [
        :_destroy,
        :description,
        :id,
        :title,
      ],
      safety_concerns_attributes: [
        :_destroy,
        :category,
        :description,
        :id,
        :physical_or_threat,
      ],
    )
  end

  def ensure_response_plan_is_approved(response_plan)
    unless response_plan.approved?
      raise ActiveRecord::RecordNotFound
    end
  end
end
