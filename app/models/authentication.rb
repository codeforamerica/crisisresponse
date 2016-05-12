class Authentication
  include ActiveModel::Model

  attr_accessor :username, :password

  def attempt_sign_on
    ldap_object.bind
  end

  def officer_information
    object = ldap_object.search(base: ldap_user_path).first

    {
      name: "#{object[:givenname].first} #{object[:sn].first}",
      username: object[:cn].first,
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

  def ldap_user_path
    namespace = ENV.fetch('LDAP_NAMESPACE')
    "cn=#{username},#{namespace}"
  end
end
