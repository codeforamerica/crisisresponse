require "rails_helper"
require "support/permissions"

RSpec.describe ResponsePlansController, type: :controller do
  include Permissions

  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :index, {}, { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end
  end

  describe "GET #index" do
    context "as a non-admin" do
      scenario "they do not see response plans that have not been approved" do
        officer = create(:officer)
        approved = create(:response_plan)
        _unapproved = create(:response_plan, approver: nil)

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to eq([approved])
      end
    end

    context "as an admin" do
      scenario "they see response plans that have not been approved" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        approved = create(:response_plan)
        unapproved = create(:response_plan, approver: nil)

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to match_array([approved, unapproved])
      end
    end
  end

  describe "GET #show" do
    context "when the plan has not been approved" do
      scenario "they do not see the response plan" do
        officer = create(:officer)
        _response_plan = create(:response_plan, approver: nil)

        expect { get :show, { id: 20 }, { officer_id: officer.id } }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
