class EmailService
  def initialize(message)
    @message = message
  end

  def self.send(message)
    new(message).send
  end

  attr_reader :message

  def send
    `#{command}`
  end

  def command
    recipients = message.to.join(",")
    sender = message.from.first

    "./bin/send_email \"#{recipients}\" \"#{sender}\" \"#{message.subject}\" \"#{message.body}\""
  end
end
