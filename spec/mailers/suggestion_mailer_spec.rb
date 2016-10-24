require "rails_helper"

RSpec.describe SuggestionMailer, type: :mailer do
  describe "created" do
    it "includes the person's name in the email subject" do
      suggestion = create(:suggestion)

      mail = SuggestionMailer.created(suggestion)

      expect(mail.subject).
        to eq("New suggestion for #{suggestion.person_name}'s response plan")
    end

    it "pulls the recipients from the ENV variable" do
      recipients = ["foo@bar.com", "baz@bar.com"]
      allow(ENV).to receive(:fetch).
        with("CONTENT_ADMIN_EMAIL").
        and_return(recipients.join(","))

      mail = SuggestionMailer.created(create(:suggestion))

      expect(mail.to).to eq(recipients)
    end

    pending "has a reply_to address of the officer who sent it" do
      officer = create(:officer, email: "foo@bar.com")
      suggestion = create(:suggestion, officer: officer)

      mail = SuggestionMailer.created(suggestion)

      expect(mail.from).to eq([officer.email])
    end

    it "marks the subject as 'urgent' if appropriate" do
      suggestion = create(:suggestion, urgent: true)

      mail = SuggestionMailer.created(suggestion)

      expect(mail.subject).to start_with("[URGENT] New suggestion for")
    end

    it "renders the body" do
      suggestion = create(:suggestion)

      mail = SuggestionMailer.created(suggestion)

      expect(mail.body.encoded).to match("New suggestion")
    end
  end
end
