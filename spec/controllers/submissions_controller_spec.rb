require "rails_helper"

RSpec.describe SubmissionsController do
  describe "GET #index" do
    it "only shows plans that are pending approval" do
      _draft = create(:response_plan, :draft)
      submission = create(:response_plan, :submission)
      _approved = create(:response_plan, :approved)

      get :index, session: { officer_id: create(:officer, :admin).id }

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

    it "displays an error if the plan is not a draft" do
      plan = create(:response_plan, :approved)

      expect do
      post(
        :create,
        params: { response_plan_id: plan.id },
        session: { officer_id: create(:officer, :admin).id },
      )
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "submits the response plan for approval" do
      plan = create(:response_plan, :draft)

      post(
        :create,
        params: { response_plan_id: plan.id },
        session: { officer_id: create(:officer, :admin).id },
      )

      plan.reload
      expect(plan).not_to be_draft
      expect(plan).to be_submitted
    end
  end

  describe "PATCH #approve" do
    it "approves the response plan if it is pending approval" do
      officer = create(:officer, :admin)
      plan = create(:response_plan, :submission)

      patch(
        :approve,
        params: { id: plan },
        session: { officer_id: officer.id },
      )

      expect(response).to redirect_to(person_path(plan.person))
      expect(flash[:notice]).
        to eq t("submissions.approve.success", name: plan.person.name)
      expect(plan.reload).to be_approved
      expect(plan.approver).to eq(officer)
    end

    it "displays an error if the plan has not been submitted" do
      plan = create(:response_plan, :draft)

      patch(
        :approve,
        params: { id: plan },
        session: { officer_id: create(:officer, :admin).id },
      )

      expect(response).to redirect_to(person_path(plan.person))
      expect(flash[:alert]).
        to eq t("submissions.approve.failure.not_submitted", name: plan.person.name)
      expect(plan.reload).not_to be_approved
    end

    it "displays an error if the plan has already been approved" do
      plan = create(:response_plan, :approved)

      patch(
        :approve,
        params: { id: plan },
        session: { officer_id: create(:officer, :admin).id },
      )

      expect(response).to redirect_to(person_path(plan.person))
      expect(flash[:alert]).
        to eq t("submissions.approve.failure.already_approved", name: plan.person.name)
      expect(plan.reload).to be_approved
    end

    it "rejects non-admins" do
      officer = create(:officer)
      submission = create(:response_plan, :submission)

      patch(
        :approve,
        params: { id: submission.id },
        session: { officer_id: officer.id },
      )

      expect(response).to redirect_to(people_path)
      expect(submission.reload).not_to be_approved
    end
  end

  describe "DELETE #destroy" do
    it "rejects non-admins" do
      officer = create(:officer)
      submission = create(:response_plan, :submission)

      delete(
        :destroy,
        params: { id: submission.id },
        session: { officer_id: officer.id },
      )

      expect(response).to redirect_to(people_path)
      expect(submission.reload).to be_submitted
    end

    it "kicks a submission back down to a draft" do
      officer = create(:officer, :admin)
      submission = create(:response_plan, :submission)

      delete(
        :destroy,
        params: { id: submission.id },
        session: { officer_id: officer.id },
      )

      submission.reload
      expect(response).to redirect_to(draft_path(submission))
      expect(submission).not_to be_submitted
      expect(submission).to be_draft
    end

    it "fails for plans that have already been approved" do
      officer = create(:officer, :admin)
      submission = create(:response_plan, :approved)

      delete(
        :destroy,
        params: { id: submission.id },
        session: { officer_id: officer.id },
      )

      submission.reload
      expect(response).to redirect_to person_path(submission.person)
      expect(submission).to be_approved
      expect(submission).not_to be_draft
      expect(submission.submitted_for_approval_at).not_to be_nil
    end
  end
end
