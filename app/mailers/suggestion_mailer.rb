# frozen_string_literal: true

class SuggestionMailer < ApplicationMailer
  URGENT_PREFIX = "[URGENT] "

  def created(suggestion)
    @suggestion = suggestion

    subject = "New suggestion for #{@suggestion.person_name}'s response plan"

    if @suggestion.urgent
      subject = URGENT_PREFIX + subject
    end

    mail(to: ENV.fetch("CONTENT_ADMIN_EMAIL"), subject: subject)
  end
end
