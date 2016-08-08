require "rails_helper"
require "support/permissions"

RSpec.describe PeopleController, type: :controller do
  include Permissions
  render_views

  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :index, {}, { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end
  end

  describe "GET #index" do
    it "shows people who do not have a response plan" do
      officer = create(:officer)
      rms_person = create(:rms_person, first_name: "John", last_name: "Doe")
      person = rms_person.person

      get :index, {}, { officer_id: officer.id }

      expect(assigns(:response_plans)).to eq(person => nil)
    end

    context "as a non-admin" do
      it "does not show response plans that have not been approved" do
        officer = create(:officer)
        approved = create(:response_plan)
        unapproved = create(:response_plan, approver: nil)

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to eq(
          approved.person => approved,
          unapproved.person => nil,
        )
      end
    end

    context "as an admin" do
      it "shows response plans that have not been approved" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        approved = create(:response_plan)
        unapproved = create(:response_plan, approver: nil)

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to eq(
          approved.person => approved,
          unapproved.person => unapproved,
        )
      end
    end
  end

  describe "GET #show" do
    context "when the plan has not been approved" do
      it "does not show the response plan information" do
        officer = create(:officer)
        person = create(:person)

        get :show, { id: person.id }, { officer_id: officer.id }

        expect(assigns(:response_plan)).to be_nil
      end
    end

    context "when the response plan has been approved" do
      it "records a PageView" do
        officer = create(:officer)
        person = create(:person)

        expect do
          get :show, { id: person.id }, { officer_id: officer.id }
        end.to change(PageView, :count).by(1)

        page_view = PageView.last
        expect(page_view.officer).to eq(officer)
        expect(page_view.person).to eq(person)
      end
    end
  end
end
