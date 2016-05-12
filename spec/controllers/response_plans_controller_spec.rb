require 'rails_helper'

RSpec.describe ResponsePlansController, type: :controller do
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
