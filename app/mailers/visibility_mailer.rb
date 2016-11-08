# frozen_string_literal: true

class VisibilityMailer < ApplicationMailer
  def crossed_threshold(visibility)
    @person = visibility.person
    date = visibility.created_at.to_date

    mail(
      to: ENV.fetch("CONTENT_ADMIN_EMAIL"),
      subject: "[RideAlong Response] New Core Profile Generated - #{l(date)}",
    )
  end
end
