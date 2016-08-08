require "email_service"

class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    feedback = Feedback.create(feedback_params)

    message = FeedbackMailer.officer_feedback(feedback)
    EmailService.send(message)

    redirect_to people_path, notice: t("feedbacks.create.success")
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :description)
  end
end
