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

  describe "GET #edit" do
    it "makes a copy of the response plan for the user to edit" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:response_plan, background_info: "hello")

      get :edit, { id: original.id }, { officer_id: officer.id }

      plan = assigns(:response_plan)
      expect(plan.background_info).to eq(original.background_info)
      expect(plan).not_to be_persisted
    end

    it "associates the copy with the original person" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      person = create(:person)
      original = create(:response_plan, background_info: "hello")

      get :edit, { id: original.id }, { officer_id: officer.id }

      plan = assigns(:response_plan)
      expect(plan.person).to eq(original.person)
      expect(plan.person).to be_persisted
    end

    it "copies over contacts" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:contact, name: "Ann", relationship: "mother")

      get :edit, { id: original.response_plan.id }, { officer_id: officer.id }

      clone = assigns(:response_plan).contacts.first
      expect(clone.name).to eq(original.name)
      expect(clone.relationship).to eq(original.relationship)
      expect(clone).not_to be_persisted
    end

    it "copies over deescalation_techniques" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:deescalation_technique, description: "bar")

      get :edit, { id: original.response_plan.id }, { officer_id: officer.id }

      clone = assigns(:response_plan).deescalation_techniques.first
      expect(clone.description).to eq(original.description)
      expect(clone).not_to be_persisted
    end

    it "copies over response_strategies" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:response_strategy, priority: 1, title: "foo", description: "bar")

      get :edit, { id: original.response_plan.id }, { officer_id: officer.id }

      clone = assigns(:response_plan).response_strategies.first
      expect(clone.priority).to eq(original.priority)
      expect(clone.title).to eq(original.title)
      expect(clone.description).to eq(original.description)
      expect(clone).not_to be_persisted
    end

    it "copies over safety concerns" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:safety_concern, category: "assaultive_law", physical_or_threat: :threat, description: "knife")

      get :edit, { id: original.response_plan.id }, { officer_id: officer.id }

      clone = assigns(:response_plan).safety_concerns.first
      expect(clone.description).to eq(original.description)
      expect(clone.category).to eq(original.category)
      expect(clone.physical_or_threat).to eq(original.physical_or_threat)
      expect(clone).not_to be_persisted
    end

    it "copies over triggers" do
      officer = create(:officer, username: "admin")
      stub_admin_permissions(officer)
      original = create(:trigger, description: "bar")

      get :edit, { id: original.response_plan.id }, { officer_id: officer.id }

      clone = assigns(:response_plan).triggers.first
      expect(clone.description).to eq(original.description)
      expect(clone).not_to be_persisted
    end
  end
end
