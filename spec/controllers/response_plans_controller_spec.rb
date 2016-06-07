require 'rails_helper'

RSpec.describe ResponsePlansController, type: :controller do
  describe "authentication" do
    context "when the officer ID in the session isn't in the system" do
      it "logs the user out and redirects them to sign in" do
        get :index, {}, { officer_id: 1 }

        expect(response).to redirect_to(new_authentication_path)
      end
    end
  end

  describe "GET #index" do
  end

  describe "GET #show" do
    context "when the plan has not been approved" do
      scenario "they do not see the response plan" do
        officer = create(:officer)
        response_plan = create(:response_plan, approver: nil)

        expect { get :show, { id: 20 }, { officer_id: officer.id } }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
