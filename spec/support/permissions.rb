module Permissions
  include RSpec::Mocks::ExampleMethods

  def stub_admin_permissions(officer)
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).
      with("ADMIN_USERNAMES").
      and_return(officer.username)
  end
end
