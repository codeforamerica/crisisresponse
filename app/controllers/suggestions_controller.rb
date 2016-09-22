# frozen_string_literal: true

require "email_service"

class SuggestionsController < ApplicationController
  before_action :authenticate_officer!

  def new
    person = Person.find(params[:person_id])
    @suggestion = Suggestion.new(person: person, officer: current_officer)
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)

    if @suggestion.save
      redirect_to @suggestion, notice: t("suggestions.create.success")

      message = SuggestionMailer.created(@suggestion)
      EmailService.send(message)
    else
      render :new
    end
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  private

  def suggestion_params
    params.
      require(:suggestion).
      permit(:person_id, :body, :urgent).
      merge(officer: current_officer)
  end
end
