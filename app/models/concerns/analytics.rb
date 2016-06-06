module Analytics
  def generate_analytics_token
    begin
      self.analytics_token = SecureRandom.hex
    end while self.class.exists?(analytics_token: analytics_token)
  end
end
