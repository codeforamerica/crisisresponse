# frozen_string_literal: true

require "threshold"

class VisibilitiesController < ApplicationController
  before_action :authenticate_officer!
  before_action :authorize_admin

  def new
    @visibility = Visibility.new(person: person)
  end

  def create
    visibility_params = params.
      require(:visibility).
      permit(:creation_notes).
      merge(person: person, created_by: current_officer)

    @visibility = Visibility.new(visibility_params)

    if @visibility.save
      redirect_to person_path(person), notice: t(".success", name: person.last_name)
    else
      render :new
    end
  end

  def edit
    @visibility = person.visibilities.active.first
  end

  def update
    @visibility = person.visibilities.active.first

    visibility_params = params.
      require(:visibility).
      permit(:removal_notes).
      merge(removed_by: current_officer, removed_at: Time.current)

    if @visibility.update(visibility_params)
      redirect_to person_path(person), notice: t(".success", name: person.last_name)
    else
      render :edit
    end
  end

  private

  def person
    Person.find(params[:person_id])
  end
end
