class FakeAuthentication
  include RSpec::Mocks::ExampleMethods

  def initialize(name: "Foo Bar", username: "foobar")
    @name = name
    @username = username
  end

  attr_reader :name, :username

  def stub_failure
    allow(Authentication).to receive(:new).and_return(failed_authentication)
  end

  def stub_success
    allow(Authentication).to receive(:new).and_return(successful_authentication)
  end

  private

  def successful_authentication
    Authentication.new(username: username, password: "password").tap do |auth|
      allow(auth).to receive(:attempt_sign_on).and_return(true)
      allow(auth).to receive(:officer_information).and_return(
        username: username,
        name: name,
      )
    end
  end

  def failed_authentication
    Authentication.new.tap do |auth|
      allow(auth).to receive(:attempt_sign_on).and_return(false)
      allow(auth).to receive(:officer_information).and_return({})
    end
  end

  def default_stubbed_methods
    {
      model_name: Authentication.new.model_name,
      to_key: Authentication.new.to_key,
    }
  end
end
