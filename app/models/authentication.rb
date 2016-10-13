class Authentication
  include ActiveModel::Model

  def initialize(params = {})
    @username = params[:username]
    @password = params[:password]
  end

  attr_reader :username, :password

  def attempt_sign_on
    ldap_object.bind &&
      (overriden_permitted?(username) || white_list.include?(username))
  end

  def officer_information
    {
      name: "#{ldap_result[:givenname].first} #{ldap_result[:sn].first}",
      username: ldap_result[:cn].first,
    }
  end

  private

  def ldap_object
    @_ldap_object ||= Net::LDAP.new(
      host: ENV.fetch("LDAP_HOST"),
      port: ENV.fetch("LDAP_PORT"),
      auth: {
        method: :simple,
        username: ldap_user_path,
        password: password,
      },
    )
  end

  def ldap_result
    @ldap_result ||= ldap_object.search(base: ldap_user_path).first
  end

  def ldap_user_path
    "CN=#{username},#{namespace}"
  end

  def overriden_permitted?(username)
    ENV.fetch("PERMITTED_USERNAME_OVERRIDES", "").split(",").include?(username)
  end

  # Traverses the ActiveDirectory `LDAP_WHITELIST_GROUP`
  # and any of its subtrees
  # to find users.
  #
  # When we search for an LDAP group,
  # the result is in the form:
  # [
  #   {
  #     member: ["list", "of, "users", "or", "subgroups"]
  #     ...other fields
  #   }
  #   ...other search results
  # ]
  #
  # A limitation of this method is that it requires the group tree
  # to have a depth of 2 at every leaf.
  # If that is not the case, the function is likely to fail with an error.
  def white_list
    supergroup = ldap_object.search(base: ENV.fetch("LDAP_WHITELIST_GROUP"))
    subgroups = supergroup.first[:member]

    @white_list ||= subgroups.map do |subgroup|
      ldap_object.search(base: subgroup).first[:member]
    end.flatten.map do |full_name|
      full_name.split(",").first.split("=").last
    end
  end

  def namespace
    ENV.fetch('LDAP_NAMESPACE')
  end
end
