class FeedbackMailer < ApplicationMailer
  def officer_feedback(feedback)
    @feedback = feedback

    mail(
      to: ENV.fetch("FEEDBACK_EMAIL"),
      subject: "Feedback from #{feedback.name}",
    )
  end
end
