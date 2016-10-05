# frozen_string_literal: true

class DraftsController < ApplicationController
  PERMITTED_PARAMS = [
    :background_info,
    :baseline,
    :elevated,
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
    deescalation_techniques_attributes: [:_destroy, :id, :description],
    person_attributes: PeopleController::PERSON_ATTRIBUTES,
    response_strategies_attributes: [:_destroy, :description, :id, :title],
    safety_concerns_attributes: [
      :_destroy,
      :category,
      :description,
      :go_number,
      :id,
      :occurred_on,
      :title,
    ],
    triggers_attributes: [:_destroy, :id, :title, :description, :go_number],
  ].freeze

  before_action :authenticate_officer!
  before_action :authorize_admin

  def index
    @drafts = ResponsePlan.drafts
  end

  def show
    @draft = ResponsePlan.find(params[:id])
  end

  def create
    person = Person.find(params.fetch(:person_id))

    if person.active_plan
      plan = person.active_plan.deep_clone(
        except: [
          :approver_id,
          :approved_at,
          :submitted_for_approval_at,
        ],
        include: [
          :contacts,
          :deescalation_techniques,
          :response_strategies,
          :safety_concerns,
          :triggers,
        ])
      source = "from_previous"
    else
      plan = ResponsePlan.new(person: person, author: current_officer)
      source = "from_scratch"
    end

    plan.save!

    redirect_to(
      edit_draft_path(plan),
      notice: t(".success.#{source}", name: person.name),
    )
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
        draft_path(@response_plan),
        notice: t(".success", name: @response_plan.person.name),
      )
    else
      render :edit
    end
  end

  private

  def response_plan_params
    permitted = params.require(:response_plan).permit(PERMITTED_PARAMS)
    dob = permitted[:person_attributes][:date_of_birth]
    permitted[:person_attributes][:date_of_birth] = Date.strptime(dob, "%m-%d-%Y")
    permitted
  end
end
