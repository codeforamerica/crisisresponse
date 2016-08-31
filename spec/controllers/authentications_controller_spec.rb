require "rails_helper"

describe AuthenticationsController do
  context "when the officer does not exist in our system" do
    it "creates an officer" do
      username = "foobar"
      FakeAuthentication.new.stub_success

      expect do
        post :create, params: session_params(username: username)
      end.to change(Officer, :count).by(1)
    end

    it "sets the session id to the new officer's id" do
      username = "foobar"
      FakeAuthentication.new(username: username).stub_success

      post :create, params: session_params(username: username)

      officer = Officer.find_by(username: username)
      expect(session[:officer_id]).to eq(officer.id)
    end
  end

  context "when the officer exists in our system" do
    it "does not create an officer" do
      name = "Foo Bar"
      username = "foobar"
      FakeAuthentication.new(name: name, username: username).stub_success
      create(:officer, name: name, username: username)

      expect do
        post :create, params: session_params(username: username)
      end.not_to change(Officer, :count)
    end

    it "sets the session id to the existing officer's id" do
      name = "Foo Bar"
      username = "foobar"
      officer = create(:officer, name: name, username: username)
      FakeAuthentication.new(name: name, username: username).stub_success

      post :create, params: session_params(username: username)

      expect(session[:officer_id]).to eq(officer.id)
    end
  end

  context "when the authentication fails" do
    it "does not create an officer" do
      FakeAuthentication.new.stub_failure

      expect do
        post :create, params: session_params
      end.not_to change(Officer, :count)
    end
  end

  def session_params(username: "example")
    { authentication: { username: username, password: "password" } }
  end
end
