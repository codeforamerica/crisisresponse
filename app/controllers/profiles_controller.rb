# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @people = Person.all.includes(:response_plans, :visibilities, :reviews)
    @due_for_review = @people.select(&:due_for_review?)
  end
end
