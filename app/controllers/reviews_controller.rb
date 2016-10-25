# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin

  def new
    @review = Review.new(person: person)
  end

  def create
    review_params = params.
      require(:review).
      permit(:notes).
      merge(person: person, created_by: current_officer)

    @review = Review.new(review_params)

    if @review.save
      redirect_to(
        person_path(person),
        notice: t(".success", name: person.last_name),
      )
    else
      render :new
    end
  end

  private

  def person
    Person.find(params[:person_id])
  end
end
