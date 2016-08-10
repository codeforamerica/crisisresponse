require "csv"
require "net/http"
require "rms_adapter"

class ResponsePlansController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin, except: [:index, :show]

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
        person_path(@response_plan.person),
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
        :triggers,
      ]
    )
  end

  def update
    @response_plan = ResponsePlan.find(params[:id])
    @response_plan.update_attributes(response_plan_params)
    @response_plan.author = current_officer

    if @response_plan.save
      redirect_to(
        person_path(@response_plan.person),
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
        person_path(plan.person),
        notice: t("response_plans.approval.success", name: plan.person.name),
      )
    else
      redirect_to(
        person_path(plan.person),
        alert: t("response_plans.approval.failure"),
      )
    end
  end

  private

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
      triggers_attributes: [
        :_destroy,
        :id,
        :description,
      ],
    )
  end
end
