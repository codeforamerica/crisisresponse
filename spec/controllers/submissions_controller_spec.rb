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

      get :index, session: { officer_id: officer.id }

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
  end

  describe "PATCH #approve" do
    it "approves the response plan if it is pending approval" do
      officer = create(:officer)
      stub_admin_permissions(officer)
      plan = create(:response_plan, :submission)

      patch :approve, params: { id: plan }, session: { officer_id: officer.id }

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
end
