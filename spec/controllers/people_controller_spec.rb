require "rails_helper"

RSpec.describe PeopleController, type: :controller do
  render_views

  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :index, session: { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end
  end

  describe "GET #index" do
    it "shows people who do not have a response plan" do
      officer = create(:officer, username: "foobar")
      person = create(:person, first_name: "John", last_name: "Doe")

      get :index, session: { officer_id: officer.id }

      expect(assigns(:people)).to eq([person])
    end

    it "does not show people below the threshold" do
      officer = create(:officer, username: "foobar")
      create(:person, visible: false)

      get :index, session: { officer_id: officer.id }

      expect(assigns(:people)).to be_empty
    end

    it "shows people in alphabetical order" do
      officer = create(:officer)
      charlie = create(:person, last_name: "Charlie")
      alice = create(:person, last_name: "Alice")
      bob = create(:person, last_name: "Bob")

      get :index, session: { officer_id: officer.id }

      expect(assigns(:people)).to eq([alice, bob, charlie])
    end

    it "shows people with and without an approved response plan" do
      officer = create(:officer, :admin)
      approved = create(:response_plan)
      unapproved = create(:response_plan, :submission)
      person_without_plan = create(:person)

      get :index, session: { officer_id: officer.id }

      expect(assigns(:people)).to match_array([
        approved.person,
        unapproved.person,
        person_without_plan,
      ])
    end
  end

  describe "GET #show" do
    context "when a plan is being drafted by another officer" do
      it "does not show the response plan information" do
        officer = create(:officer)
        person = create(:response_plan, :draft).person

        get(
          :show,
          params: { id: person.id },
          session: { officer_id: officer.id },
        )

        expect(assigns(:person).active_plan).to be_nil
      end
    end

    context "when a plan is being drafted by the current officer" do
      it "does not show the response plan information" do
        officer = create(:officer, :admin)
        plan = create(:response_plan, :draft, author: officer)
        person = plan.person

        get(
          :show,
          params: { id: person.id },
          session: { officer_id: officer.id },
        )

        expect(assigns(:person).active_plan).to be_nil
      end
    end

    context "when the response plan has been approved" do
      it "records a PageView" do
        officer = create(:officer)
        person = create(:person)

        expect do
          get(
            :show,
            params: { id: person.id },
            session: { officer_id: officer.id },
          )
        end.to change(PageView, :count).by(1)

        page_view = PageView.last
        expect(page_view.officer).to eq(officer)
        expect(page_view.person).to eq(person)
      end
    end
  end
end
