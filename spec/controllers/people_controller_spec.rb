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
    # TODO temporary feature flag
    # This should be adjusted when we allow all officers
    # to view people without a response plan
    context "when the officer can view people without a response plan" do
      it "shows people who do not have a response plan" do
        officer = create(:officer, username: "foobar")
        stub_view_without_response_plan_permissions(officer)
        rms_person = create(:rms_person, first_name: "John", last_name: "Doe")
        person = rms_person.person

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to eq(person => nil)
      end
    end

    # TODO temporary feature flag
    # This should be removed when we allow all officers
    # to view people without a response plan
    context "when the officer can only view people with a response plan" do
      it "does not shows people who do not have a response plan" do
        officer = create(:officer)
        rms_person = create(:rms_person, first_name: "John", last_name: "Doe")
        person = rms_person.person

        get :index, {}, { officer_id: officer.id }

        expect(assigns(:response_plans)).to eq({})
      end
    end

    it "shows people in alphabetical order" do
      officer = create(:officer)

      charlie = create(:person, last_name: "Charlie")
      alice = create(:rms_person, last_name: "Alice").person
      alice.last_name = nil
      alice.save(validate: false)
      alice.reload
      bob = create(:person, last_name: "Bob")

      # TODO these should eventually not be necessary
      create(:response_plan, person: alice)
      create(:response_plan, person: bob)
      create(:response_plan, person: charlie)

      get :index, {}, { officer_id: officer.id }

      expect(assigns(:response_plans).keys).to eq([alice, bob, charlie])
    end

    it "does not show response plans that have not been approved" do
      officer = create(:officer)
      stub_admin_permissions(officer)
      approved = create(:response_plan)
      unapproved = create(:response_plan, :submission)

      get :index, {}, { officer_id: officer.id }

      expect(assigns(:response_plans)).to eq(
        approved.person => approved,
        # TODO: For now, don't show people without a response plan.
        # We'll add them in once we have a plan
        # for the basic information layout.
        # unapproved.person => nil,
      )
    end
  end

  describe "GET #show" do
    context "when a plan is being drafted by another officer" do
      it "does not show the response plan information" do
        officer = create(:officer)
        person = create(:response_plan, :draft).person

        get :show, { id: person.id }, { officer_id: officer.id }

        expect(assigns(:person).active_plan).to be_nil
      end
    end

    context "when a plan is being drafted by the current officer" do
      it "does not show the response plan information" do
        officer = create(:officer)
        stub_admin_permissions(officer)
        plan = create(:response_plan, :draft, author: officer)
        person = plan.person

        get :show, { id: person.id }, { officer_id: officer.id }

        expect(assigns(:person).active_plan).to be_nil
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
