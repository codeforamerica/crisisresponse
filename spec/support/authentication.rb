class FakeAuthentication
  include RSpec::Mocks::ExampleMethods

  def initialize(name: "Foo Bar", username: "foobar")
    @name = name
    @username = username
  end

  attr_reader :name, :username

  def stub_failure
    allow(Net::LDAP).to receive(:new).and_return(failed_authentication_result)
  end

  def stub_success
    allow(Net::LDAP).
      to receive(:new).and_return(successful_authentication_result)
  end

  private

  def successful_authentication_result
    ldap_identity_information = {
      givenname: [name.split(" ").first],
      sn: [name.split(" ").last],
      mail: ["foo@seattle.gov"],
      cn: [username],
      memberof: [
        "CN=ValidSubgroup,#{ENV.fetch('LDAP_WHITELIST_GROUP')}",
      ],
    }

    double(bind: true, search: [ldap_identity_information])
  end

  def failed_authentication_result
    double(bind: false)
  end
end
