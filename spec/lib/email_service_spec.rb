require "spec_helper"
require "email_service"

describe EmailService do
  it "uses the correct command-line program" do
    message = double(
      to: ["foo@example.com", "bar@example.com"],
      from: ["sender@example.com", "unused@example.com"],
      subject: "Test Subject",
      body: "<h1>Hello!</h1>",
    )
    service = EmailService.new(message)

    expect(service.command).to eq(
      './bin/send_email "foo@example.com,bar@example.com" "sender@example.com" "Test Subject" "<h1>Hello!</h1>"'
    )
  end
end
