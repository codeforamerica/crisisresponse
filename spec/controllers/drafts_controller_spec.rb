require "rails_helper"
require "support/permissions"

RSpec.describe DraftsController do
  include Permissions

  describe "GET #index" do
    it "only shows plans that are drafts" do
      officer = create(:officer)
      stub_admin_permissions(officer)

      draft = create(:response_plan, :draft, author: officer)
      _draft_from_other_officer = create(:response_plan, :draft)
      _pending = create(:response_plan, :submission)
      _approved = create(:response_plan, :approved)

      get :index, {}, { officer_id: officer.id }

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
      officer = create(:officer)
      stub_admin_permissions(officer)

      post :create, { person_id: person.id }, { officer_id: officer.id }

      expect(response).to redirect_to edit_response_plan_path(ResponsePlan.last)
    end

    context "when the person does not have a response plan" do
      it "creates a new response plan for the person" do
        person = create(:person)
        officer = create(:officer)
        stub_admin_permissions(officer)

        expect do
          post :create, { person_id: person.id }, { officer_id: officer.id }
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.person).to eq(person)
        expect(plan.author).to eq(officer)
      end
    end

    context "when the person has a response plan in draft form" do
      # TODO is this what we want?
      it "ignores the information in the non-approved plan" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(
          :response_plan,
          approved_at: nil,
          approver: nil,
          background_info: "hello",
        )

        expect do
          post :create, { person_id: original.person_id }, { officer_id: officer.id }
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.person).to eq(original.person)
        expect(plan.author).to eq(officer)
        expect(plan.background_info).not_to eq(original.background_info)
      end
    end

    context "when the person already has a response plan" do
      it "makes a copy of the response plan as a draft for the user to edit" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(:response_plan, background_info: "hello")

        expect do
          post :create, { person_id: original.person_id }, { officer_id: officer.id }
        end.to change(ResponsePlan, :count).by(1)

        plan = ResponsePlan.last
        expect(plan.background_info).to eq(original.background_info)
        expect(plan).to be_persisted
        expect(plan).to be_draft
      end

      it "associates the copy with the original person" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        person = create(:person)
        original = create(:response_plan, background_info: "hello")

        post :create, { person_id: original.person_id }, { officer_id: officer.id }

        plan = ResponsePlan.last
        expect(plan.person).to eq(original.person)
        expect(plan.person).to be_persisted
      end

      it "copies over contacts" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(:contact, name: "Ann", relationship: "mother")

        post :create, { person_id: original.response_plan.person_id }, { officer_id: officer.id }

        clone = ResponsePlan.last.contacts.first
        expect(clone.name).to eq(original.name)
        expect(clone.relationship).to eq(original.relationship)
        expect(clone).to be_persisted
      end

      it "copies over deescalation_techniques" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(:deescalation_technique, description: "bar")

        post :create, { person_id: original.response_plan.person_id }, { officer_id: officer.id }

        clone = ResponsePlan.last.deescalation_techniques.first
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end

      it "copies over response_strategies" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(:response_strategy, priority: 1, title: "foo", description: "bar")

        post :create, { person_id: original.response_plan.person_id }, { officer_id: officer.id }

        clone = ResponsePlan.last.response_strategies.first
        expect(clone.priority).to eq(original.priority)
        expect(clone.title).to eq(original.title)
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end

      it "copies over triggers" do
        officer = create(:officer, username: "admin")
        stub_admin_permissions(officer)
        original = create(:trigger, description: "bar")

        post :create, { person_id: original.response_plan.person_id }, { officer_id: officer.id }

        clone = ResponsePlan.last.triggers.first
        expect(clone.description).to eq(original.description)
        expect(clone).to be_persisted
      end
    end
  end
end
