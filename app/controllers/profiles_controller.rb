# frozen_string_literal: true

class ProfilesController < ApplicationController
  RECORDS_PER_PAGE = 12

  def index
    @people = Person.
      all.
      includes(:response_plans, :visibilities, :reviews).
      page(params[:page]).
      per(RECORDS_PER_PAGE)

    @due_for_review = @people.select(&:due_for_review?)
  end
end
