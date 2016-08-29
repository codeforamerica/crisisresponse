class ApprovalsController < ApplicationController
  # Display a list of response plans pending approval
  def index
    @response_plans = ResponsePlan.pending_approval
  end

  # Submit a response plan for approval,
  # taking it out of draft form
  # and adding it to the approvals page.
  def create
    redirect_to :drafts, notice: t("response_plans.draft.submitted")
  end

  # Approve a response plan,
  # removing it from the list of pending approvals
  # and making it visible to patrol officers
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
end
