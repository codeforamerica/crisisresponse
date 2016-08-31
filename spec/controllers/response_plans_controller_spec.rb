require "rails_helper"
require "support/permissions"

RSpec.describe ResponsePlansController, type: :controller do
  include Permissions
  render_views

  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :edit, { id: 1 }, { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end

    context "when the officer is not an admin" do
      it "redirects them to the root path" do
        officer = create(:officer)

        get :edit, { id: 1 }, { officer_id: officer.id }

        expect(response).to redirect_to(people_path)
      end
    end
  end

  describe "GET #edit" do
    it "redirects if the officer is not signed in"
    it "redirects if the officer is not an admin"
    it "redirects if the plan has been approved"
    it "redirects if the plan has been submitted for approval"

    # TODO is this the behavior that we want?
    it "redirects if the current officer did not create the draft"

    it "assigns the plan if it is still in draft form" do
      officer = create(:officer)
      stub_admin_permissions(officer)
      plan = create(:response_plan)

      get :edit, { id: plan.id }, { officer_id: officer.id }

      expect(assigns(:response_plan)).to eq(plan)
    end
  end

  describe "PATCH #update" do
    it "redirects if the officer is not signed in"
    it "redirects if the officer is not an admin"

    context "if the current officer did not create the draft" do
      it "does not update the plan"
      it "redirects to the person's page"
    end

    context "if the plan has been submitted for approval" do
      it "does not update the plan"
      it "redirects to the person's page"
    end

    context "if the plan has been approved" do
      it "does not update the plan"
      it "redirects to the person's page"
    end

    context "when everything checks out okay" do
      it "updates the plan and associated records"
      it "redirects to the draft preview page"
    end
  end
end
