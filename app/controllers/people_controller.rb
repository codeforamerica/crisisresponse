require "csv"
require "net/http"
require "rms_adapter"

class PeopleController < ApplicationController
  def index
    @search = PersonSearch.new(search_params)
    @people = @search.close_matches
  end

  def show
    first_name, last_name = params[:id].titleize.split
    @person = Person.find_by(first_name: first_name, last_name: last_name)
    @events = events_for(@person)

    @plan = find_most_recent_plan_for_person(@person)

    if @events.none?
      redirect_to :people, alert: "Could not find any records for #{@person.name}"
    end
  end

  private

  def events_for(person)
    rms = RMSAdapter.new
    rms.events_for(person)
  end

  def find_most_recent_plan_for_person(person)
    ResponsePlanBuilder.build({})
  end

  def search_params
    if params[:person_search].present?
      params.require(:person_search).permit(:name, :date_of_birth)
    else
      {}
    end
  end
end
