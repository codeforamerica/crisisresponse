class DraftsController < ApplicationController
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
    redirect_to edit_response_plan_path(plan)
  end
end
