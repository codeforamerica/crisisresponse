require "rails_helper"

RSpec.describe DraftsController do
  render_views

  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :edit, params: { id: 1 }, session: { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end

    context "when the officer is not an admin" do
      it "redirects them to the root path" do
        officer = create(:officer)

        get :edit, params: { id: 1 }, session: { officer_id: officer.id }

        expect(response).to redirect_to(people_path)
      end
    end
  end

  describe "GET #index" do
    it "only shows plans that are drafts" do
      officer = create(:officer, :admin)
      draft = create(:response_plan, :draft, author: officer)
      _draft_from_other_officer = create(:response_plan, :draft)
      _pending = create(:response_plan, :submission)
      _approved = create(:response_plan, :approved)

      get :index, session: { officer_id: officer.id }

      expect(assigns(:drafts)).to eq([draft])
    end
  end

  describe "GET #show" do
    it "assigns the response plan to `@response_plan`"
    it "assigns the person to `@person`"
  end

  describe "POST #create" do
    it "redirects to #edit" do
      person = create(:person)
      officer = create(:officer, :admin)

      post(
        :create,
        params: { person_id: person.id },
        session: { officer_id: officer.id },
      )

      expect(response).to redirect_to edit_draft_path(ResponsePlan.last)
    end

    context "when the person does not have a response plan" do
      it "creates a new response plan for the person" do
        person = create(:person)
        officer = create(:officer, :admin)

        expect do
          post(
            :create,
            params: { person_id: person.id },
            session: { officer_id: officer.id },
          )
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.person).to eq(person)
        expect(plan.author).to eq(officer)
      end
    end

    context "when the person has a response plan in draft form" do
      it "ignores the information in the non-approved plan" do
        officer = create(:officer, :admin)
        original = create(
          :response_plan,
          approved_at: nil,
          approver: nil,
          background_info: "hello",
        )

        expect do
          post(
            :create,
            params: { person_id: original.person_id },
            session: { officer_id: officer.id },
          )
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.person).to eq(original.person)
        expect(plan.author).to eq(officer)
        expect(plan.background_info).not_to eq(original.background_info)
      end
    end

    context "when the person already has a response plan" do
      it "makes a copy of the response plan as a draft for the user to edit" do
        officer = create(:officer, :admin)
        original = create(:response_plan, background_info: "hello")

        expect do
          post(
            :create,
            params: { person_id: original.person_id },
            session: { officer_id: officer.id },
          )
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.background_info).to eq(original.background_info)
        expect(plan).to be_persisted
        expect(plan).to be_draft
      end

      it "associates the copy with the original person" do
        officer = create(:officer, :admin)
        person = create(:person)
        original = create(:response_plan, background_info: "hello")

        post(
          :create,
          params: { person_id: original.person_id },
          session: { officer_id: officer.id },
        )

        plan = ResponsePlan.last
        expect(plan.person).to eq(original.person)
        expect(plan.person).to be_persisted
      end

      it "copies over contacts" do
        officer = create(:officer, :admin)
        original = create(:contact, name: "Ann", relationship: "mother")

        post(
          :create,
          params: { person_id: original.response_plan.person_id },
          session: { officer_id: officer.id },
        )

        clone = ResponsePlan.last.contacts.first
        expect(clone.name).to eq(original.name)
        expect(clone.relationship).to eq(original.relationship)
        expect(clone).to be_persisted
      end

      it "copies over deescalation_techniques" do
        officer = create(:officer, :admin)
        original = create(:deescalation_technique, description: "bar")

        post(
          :create,
          params: { person_id: original.response_plan.person_id },
          session: { officer_id: officer.id },
        )

        clone = ResponsePlan.last.deescalation_techniques.first
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end

      it "copies over response_strategies" do
        officer = create(:officer, :admin)
        original = create(:response_strategy, priority: 1, title: "foo", description: "bar")

        post(
          :create,
          params: { person_id: original.response_plan.person_id },
          session: { officer_id: officer.id },
        )

        clone = ResponsePlan.last.response_strategies.first
        expect(clone.priority).to eq(original.priority)
        expect(clone.title).to eq(original.title)
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end

      it "copies over safety concerns" do
        officer = create(:officer, :admin)
        original = create(
          :safety_concern,
          category: "assaultive_law",
          description: "knife",
        )

        post(
          :create,
          params: { person_id: original.response_plan.person_id },
          session: { officer_id: officer.id },
        )

        clone = ResponsePlan.last.safety_concerns.first
        expect(clone.description).to eq(original.description)
        expect(clone.category).to eq(original.category)
        expect(clone).to be_persisted
      end

      it "copies over triggers" do
        officer = create(:officer, :admin)
        original = create(:trigger, title: "foo", description: "bar")

        post(
          :create,
          params: { person_id: original.response_plan.person_id },
          session: { officer_id: officer.id },
        )

        clone = ResponsePlan.last.triggers.first
        expect(clone.title).to eq(original.title)
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end
    end
  end

  describe "GET #edit" do
    it "redirects if the officer is not signed in"
    it "redirects if the officer is not an admin"
    it "redirects if the plan has been approved"
    it "redirects if the plan has been submitted for approval"
    it "redirects if the current officer did not create the draft"

    it "assigns the plan if it is still in draft form" do
      officer = create(:officer, :admin)
      plan = create(:response_plan)

      get(
        :edit,
        params: { id: plan.id },
        session: { officer_id: officer.id },
      )

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
