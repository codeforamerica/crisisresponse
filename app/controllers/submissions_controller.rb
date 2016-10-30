# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin
  before_action :authorize_owner, only: [:approve]

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

    message = [
      t(".success.text"),
      view_context.link_to(t(".success.link")),
    ].join(" ")

    redirect_to :drafts, notice: message
  end

  # Approve a response plan,
  # removing it from the list of submissions pending approval
  # and making it visible to patrol officers
  def approve
    plan = ResponsePlan.find(params[:id])

    if plan.approved?
      flashes = { alert: t(".failure.already_approved", name: plan.person.name) }
    elsif !plan.submitted?
      flashes = { alert: t(".failure.not_submitted", name: plan.person.name) }
    else
      plan.update!(approver: current_officer)
      create_approval_visibility(plan.person)
      flashes = { notice: t(".success", name: plan.person.name) }
    end

    redirect_to person_path(plan.person), flashes
  end

  # Revert a submitted response plan back into draft mode,
  # so CRT officers can continue to make edits to it.
  def destroy
    plan = ResponsePlan.find(params[:id])

    if plan.submitted?
      plan.update!(submitted_for_approval_at: nil)
      redirect_to draft_path(plan), notice: t(".success", name: plan.person.name)
    else
      redirect_to person_path(plan.person), alert: t(".failure")
    end
  end

  private

  def create_approval_visibility(person)
    unless person.visible?
      Visibility.create!(
        person: person,
        created_by: current_officer,
        creation_notes: "A response plan was approved and published to patrol",
      )
    end
  end
end
