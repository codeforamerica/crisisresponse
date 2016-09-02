class SubmissionsController < ApplicationController
  # Display a list of response plans pending approval
  def index
    @submissions = ResponsePlan.submitted
  end

  # Display a single response plan pending approval
  def show
    @submission = ResponsePlan.find(params[:id])
  end

  # Submit a response plan for approval,
  # taking it out of draft form
  # and adding it to the submissions page.
  def create
    plan = ResponsePlan.drafts.find(params[:response_plan_id])
    plan.update!(submitted_for_approval_at: Time.current)
    redirect_to :drafts, notice: t(".success")
  end

  # Approve a response plan,
  # removing it from the list of submissions pending approval
  # and making it visible to patrol officers
  def approve
    plan = ResponsePlan.find(params[:id])
    plan.approver = current_officer

    if plan.save
      redirect_to(
        person_path(plan.person),
        notice: t(".success", name: plan.person.name),
      )
    else
      redirect_to(
        person_path(plan.person),
        alert: t(".failure"),
      )
    end
  end
end
