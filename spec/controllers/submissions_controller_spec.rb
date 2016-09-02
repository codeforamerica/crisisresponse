require "rails_helper"
require "support/permissions"

RSpec.describe SubmissionsController do
  include Permissions

  describe "GET #index" do
    it "only shows plans that are pending approval" do
      _draft = create(:response_plan, :draft)
      submission = create(:response_plan, :submission)
      _approved = create(:response_plan, :approved)

      get :index, session: stubbed_admin_session

      expect(assigns(:submissions)).to eq([submission])
    end

    context "as a non-admin" do
      it "rejects the user"
    end
  end

  describe "GET #show" do
    it "assigns the response plan to `@response_plan`"
    it "assigns the person to `@person`"
  end

  describe "POST #create" do
    it "displays an error if the user is not the author"

    it "displays an error if the plan is not a draft" do
      plan = create(:response_plan, :approved)

      expect do
      post(
        :create,
        params: { response_plan_id: plan.id },
        session: stubbed_admin_session,
      )
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "submits the response plan for approval" do
      plan = create(:response_plan, :draft)

      post(
        :create,
        params: { response_plan_id: plan.id },
        session: stubbed_admin_session,
      )

      plan.reload
      expect(plan).not_to be_draft
      expect(plan).to be_submitted
    end
  end

  describe "PATCH #approve" do
    it "approves the response plan if it is pending approval" do
      officer = create(:officer)
      plan = create(:response_plan, :submission)

      patch(
        :approve,
        params: { id: plan },
        session: stubbed_admin_session(officer),
      )

      expect(response).to redirect_to(person_path(plan.person))
      expect(flash[:notice]).
        to eq t("submissions.approve.success", name: plan.person.name)
      expect(plan.reload).to be_approved
      expect(plan.approver).to eq(officer)
    end

    it "displays an error if the plan is a draft"
    it "displays an error if the plan has already been approved"

    context "as a non-admin" do
      it "rejects the user"
    end
  end

  def stubbed_admin_session(officer = create(:officer))
    stub_admin_permissions(officer)
    { officer_id: officer.id }
  end
end
