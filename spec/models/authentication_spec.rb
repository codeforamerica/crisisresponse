# frozen_string_literal: true

require "rails_helper"

describe Authentication do
  WHITELIST_GROUP = "OU=SuperGroup,DC=DOMAIN,DC=DOMAIN"
  BLACKLIST_GROUP = "CN=Group,OU=SuperGroup,DC=DOMAIN,DC=DOMAIN"

  describe "#attempt_sign_on" do
    it "returns false if the officer does not exist in ActiveDirectory" do
      skip "Stub the behavior that Net::LDAP uses when there is not a person"

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to eq(false)
    end

    it "returns false if the officer does not belong to the whitelist group" do
      stub_env_vars

      stub_ldap_object(memberof: [
        "CN=AcceptableGroup,OU=OtherGroup,DC=Domain,DC=Domain",
      ])

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_falsey
    end


    it "returns false if the officer does belongs to the blacklist group" do
      stub_env_vars
      stub_ldap_object(memberof: [
        BLACKLIST_GROUP,
      ])

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_falsey
    end

    it "returns true if the officer is in another white group besides the black group" do
      stub_env_vars
      stub_ldap_object(memberof: [
        "CN=AcceptableGroup,#{WHITELIST_GROUP}",
        BLACKLIST_GROUP,
      ])

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_truthy
    end

    it "returns true if the officer is in a whitelist subgroup that is not the blacklist" do
      stub_env_vars
      stub_ldap_object(memberof: ["CN=AcceptableGroup,#{WHITELIST_GROUP}"])

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_truthy
    end
  end

  describe "#officer_information" do
    it "parses out the officer's name" do
      stub_env_vars
      stub_ldap_object(givenname: ["First"], sn: ["Last"])

      auth = Authentication.new(username: "foo", password: "bar")
      auth.attempt_sign_on
      info = auth.officer_information

      expect(info[:name]).to eq("First Last")
    end

    it "parses out the officer's username" do
      stub_env_vars
      stub_ldap_object(cn: ["username"])

      auth = Authentication.new(username: "foo", password: "bar")
      auth.attempt_sign_on
      info = auth.officer_information

      expect(info[:username]).to eq("username")
    end

    pending "parses out the officer's email" do
      stub_env_vars
      stub_ldap_object(mail: ["example@seattle.gov"])

      auth = Authentication.new(username: "foo", password: "bar")
      auth.attempt_sign_on
      info = auth.officer_information

      expect(info[:email]).to eq("example@seattle.gov")
    end
  end

  private

  def stub_env_vars
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).
      with("LDAP_WHITELIST_GROUP").
      and_return(WHITELIST_GROUP)
    allow(ENV).to receive(:fetch).
      with("LDAP_BLACKLIST_GROUP").
      and_return(BLACKLIST_GROUP)
  end

  def stub_ldap_object(overrides = {})
    ldap_result = default_ldap_attributes.merge(overrides)

    fake_ldap_connection = double(
      "LDAP connection",
      bind: true,
      search: [ldap_result],
    )

    allow(Net::LDAP).to receive(:new).and_return(fake_ldap_connection)
    fake_ldap_connection
  end

  def default_ldap_attributes
    {
      dn: ["CN=doej,#{namespace}"],
      objectclass: ["top", "person", "organizationalPerson", "user"],
      cn: ["doej"],
      sn: ["Doe"],
      description: ["Officer who belongs to some units"],
      givenname: ["Jane"],
      initials: ["B"],
      distinguishedname: ["CN=doej,#{namespace}"],
      instancetype: ["4"],
      whencreated: ["20160101010101.0Z"],
      whenchanged: ["20160101010101.0Z"],
      displayname: ["X123 Doe, Jane B."],
      usncreated: ["123456789"],
      memberof:  ["CN=Group,OU=SuperGroup,DC=Domain,DC=Domain"],
      usnchanged: ["123456789"],
      name: ["doej"],
      objectguid: ["0123456789abcdef"],
      useraccountcontrol: ["123"],
      badpwdcount: ["0"],
      codepage: ["0"],
      countrycode: ["0"],
      homedirectory: ["\\\\rootpath\\doej"],
      homedrive: ["H:"],
      badpasswordtime: ["131200000000000000"],
      lastlogoff: ["0"],
      lastlogon: ["131200000000000000"],
      scriptpath: ["script.bat"],
      pwdlastset: ["131200000000000000"],
      primarygroupid: ["123"],
      objectsid: ["0123456789abcdef_0123456789abcdef_0123456789abcdef"],
      accountexpires: ["1312000000000000000"],
      logoncount: ["001"],
      samaccountname: ["doej"],
      samaccounttype: ["123456789"],
      userprincipalname: ["doej@Police.Seattle"],
      objectcategory: ["CN=Person,CN=Schema,CN=Configuration,DC=Police,DC=Seattle"],
      dscorepropagationdata: ["20160101010101.0Z", "20160101010101.0Z", "20160101010101.0Z", "20160101010101.0Z", "20160101010101.0Z"],
      lastlogontimestamp: ["131200000000000000"],
      mail: ["jane.doe@seattle.gov"],
      altguid: ["0123456789abcdef"],
      altupn: ["jane.doe@seattle.gov"],
    }
  end

  def namespace
    ENV.fetch("LDAP_NAMESPACE")
  end
end
