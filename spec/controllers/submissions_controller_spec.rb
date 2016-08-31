require "rails_helper"
require "support/permissions"

RSpec.describe SubmissionsController do
  include Permissions

  describe "GET #index" do
    it "only shows plans that are pending approval" do
      officer = create(:officer)
      stub_admin_permissions(officer)

      _draft = create(:response_plan, :draft)
      submission = create(:response_plan, :submission)
      _approved = create(:response_plan, :approved)

      get :index, {}, { officer_id: officer.id }

      expect(assigns(:response_plans)).to eq([submission])
    end

    context "as a non-admin" do
      it "rejects the user"
    end
  end

  describe "POST #create" do
    it "approves a plan"

    it "cannot approve plans that are still being drafted"

    it "cannot approve plans that have already been approved"

    it "does not approve the plan unless the user is an admin"
  end

  describe "PATCH #approve" do
    it "approves the response plan if it is pending approval" do
      officer = create(:officer)
      stub_admin_permissions(officer)
      plan = create(:response_plan, :submission)

      patch :approve, { id: plan }, { officer_id: officer }

      expect(response).to redirect_to(person_path(plan.person))
      expect(plan.reload).to be_approved
      expect(plan.approver).to eq(officer)
    end

    it "displays an error if the plan is a draft"
    it "displays an error if the plan has already been approved"

    context "as a non-admin" do
      it "rejects the user"
    end
  end
end
