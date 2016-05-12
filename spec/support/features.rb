require "rack_session_access/capybara"

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl

  def sign_in_officer(officer = create(:officer))
    page.set_rack_session(officer_id: officer.id)
  end
end
