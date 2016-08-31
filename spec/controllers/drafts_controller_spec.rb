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

      expect(assigns(:response_plans)).to eq([draft])
    end
  end
end
