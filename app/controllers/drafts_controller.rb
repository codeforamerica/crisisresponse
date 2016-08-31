class DraftsController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin

  def index
    @drafts = ResponsePlan.drafts.where(author: current_officer)
  end

  def show
    @draft = ResponsePlan.find(params[:id])
  end

  def create
    person = Person.find(params.fetch(:person_id))

    if person.active_response_plan
      plan = person.active_response_plan.deep_clone(
        except: [
          :approver_id,
          :approved_at,
          :submitted_for_approval_at,
        ],
        include: [
          :contacts,
          :deescalation_techniques,
          :response_strategies,
          :triggers,
        ])
    else
      plan = ResponsePlan.new(person: person, author: current_officer)
    end

    plan.save!
    redirect_to edit_draft_path(plan)
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
        notice: t("response_plans.update.success", name: @response_plan.person.name),
      )
    else
      render :edit
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
        :height_feet,
        :height_inches,
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
