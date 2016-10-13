# frozen_string_literal: true

require "rails_helper"

describe Authentication do
  WHITELIST_GROUP = "OU=SuperGroup,DC=DOMAIN,DC=DOMAIN"

  describe "#attempt_sign_on" do
    it "returns false if the officer does not exist in ActiveDirectory" do
      skip "Stub the behavior that Net::LDAP uses when there is not a person"

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to eq(false)
    end

    it "returns false if the officer does not belong to the whitelist group" do
      stub_env_vars
      stub_ldap_user_search("foo")
      stub_ldap_group(WHITELIST_GROUP, member: [])

      auth = Authentication.new(username: "foo", password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_falsey
    end

    it "returns true if the officer is in a whitelist subgroup" do
      username = "foo"
      intermediate_group = "CN=Foo,OU=Bar,#{namespace}"
      stub_env_vars
      stub_ldap_user_search(username)
      stub_ldap_group(WHITELIST_GROUP, member: [intermediate_group])
      stub_ldap_group(intermediate_group, member: ["CN=#{username},#{namespace}"])

      auth = Authentication.new(username: username, password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_truthy
    end

    it "returns true if the officer is in an override list" do
      username = "username"
      stub_env_vars
      stub_ldap_user_search(username)
      allow(ENV).to receive(:fetch).
        with("PERMITTED_USERNAME_OVERRIDES", "").
        and_return("#{username},username2")

      auth = Authentication.new(username: username, password: "bar")
      result = auth.attempt_sign_on

      expect(result).to be_truthy
    end
  end

  describe "#officer_information" do
    it "parses out the officer's name" do
      intermediate_group = "CN=Foo,OU=Bar,#{namespace}"
      stub_env_vars
      stub_ldap_group(WHITELIST_GROUP, member: [intermediate_group])
      stub_ldap_group(intermediate_group, member: ["CN=foo,#{namespace}"])
      stub_ldap_user_search("foo", givenname: ["First"], sn: ["Last"])

      auth = Authentication.new(username: "foo", password: "bar")
      auth.attempt_sign_on
      info = auth.officer_information

      expect(info[:name]).to eq("First Last")
    end

    it "parses out the officer's username" do
      intermediate_group = "CN=Foo,OU=Bar,#{namespace}"
      stub_env_vars
      stub_ldap_user_search("username", cn: ["username"])
      stub_ldap_group(WHITELIST_GROUP, member: [intermediate_group])
      stub_ldap_group(intermediate_group, member: ["CN=foo,#{namespace}"])

      auth = Authentication.new(username: "username", password: "bar")
      auth.attempt_sign_on
      info = auth.officer_information

      expect(info[:username]).to eq("username")
    end

    pending "parses out the officer's email" do
      stub_env_vars
      stub_ldap_user_search(username, mail: ["example@seattle.gov"])

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
      with("PERMITTED_USERNAME_OVERRIDES", "").
      and_return("")
    allow(ENV).to receive(:fetch).
      with("LDAP_NAMESPACE").
      and_return("DC=Domain,DC=Domain")
    allow(ENV).to receive(:fetch).
      with("LDAP_WHITELIST_GROUP").
      and_return(WHITELIST_GROUP)
  end

  def stub_ldap_user_search(username, overrides = {})
    ldap_result = default_ldap_attributes.merge(overrides)

    allow(ldap_connection).to receive(:search).
      with(base: "CN=#{username},#{namespace}").
      and_return([ldap_result])
  end

  def ldap_connection
    @ldap_connection ||= double("LDAP connection", bind: true).tap do |conn|
      allow(conn).to receive(:search).and_return([])
      allow(Net::LDAP).to receive(:new).and_return(conn)
    end
  end

  def stub_ldap_group(group_name, options)
    allow(ldap_connection).to receive(:search).
      with(base: group_name).
      and_return([default_ldap_group.merge(options)])
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
      objectcategory: ["CN=Person,CN=Schema,CN=Configuration,#{namespace}"],
      dscorepropagationdata: ["16010101000000.0Z"],
      lastlogontimestamp: ["131200000000000000"],
      mail: ["jane.doe@seattle.gov"],
      altguid: ["0123456789abcdef"],
      altupn: ["jane.doe@seattle.gov"],
    }
  end

  def default_ldap_group
    {
      dn: [WHITELIST_GROUP],
      objectclass: ["top", "group"],
      cn: ["group"],
      description: ["RideAlong Response app access"],
      member: ["CN=user,CN=Users,#{namespace}"],
      distinguishedname: [WHITELIST_GROUP],
      instancetype: ["4"],
      whencreated: ["20160101010101.0Z"],
      whenchanged: ["20160101010101.0Z"],
      usncreated: ["123456789"],
      info: ["Info about the group"],
      usnchanged: ["123456789"],
      name: ["group"],
      objectguid: ["0123456789abcdef"],
      objectsid: ["0123456789abcdef_0123456789abcdef_0123456789abcdef"],
      samaccountname: ["group"],
      samaccounttype: ["123456789"],
      grouptype: ["123456789"],
      objectcategory: ["CN=Group,CN=Schema,CN=Configuration,#{namespace}"],
      dscorepropagationdata: ["16010101000000.0Z"],
    }
  end

  def namespace
    ENV.fetch("LDAP_NAMESPACE")
  end
end
