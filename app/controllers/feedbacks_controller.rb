class FeedbacksController < ApplicationController
  def new
     @feedback = Feedback.new
  end

  def create
    Feedback.create(feedback_params)
    redirect_to response_plans_path, notice: t("feedbacks.create.success")
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :description)
  end
end
