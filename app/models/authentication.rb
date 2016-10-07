class Authentication
  include ActiveModel::Model

  def initialize(params = {})
    @username = params[:username]
    @password = params[:password]
  end

  attr_reader :username, :password

  def attempt_sign_on
    ldap_object.bind &&
      belongs_to_valid_whitelist_group
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
    namespace = ENV.fetch('LDAP_NAMESPACE')
    "cn=#{username},#{namespace}"
  end

  def belongs_to_valid_whitelist_group
    Array(ldap_result[:memberof]).
      select { |group| group.ends_with?(white_list) }.
      without(black_list).
      any?
  end

  def white_list
    ENV.fetch("LDAP_WHITELIST_GROUP")
  end

  def black_list
    ENV.fetch("LDAP_BLACKLIST_GROUP")
  end
end
