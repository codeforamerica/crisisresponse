module Permissions
  include RSpec::Mocks::ExampleMethods

  def stub_admin_permissions(officer)
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).
      with("ADMIN_USERNAMES").
      and_return(officer.username)
  end

  # TODO temporary flag.
  # This should be removed when we release the feature for all officers
  # to view people who don't have response plans.
  def stub_view_without_response_plan_permissions(officer)
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).
      with("CAN_VIEW_WITHOUT_RESPONSE_PLANS").
      and_return(officer.username)
  end
end
