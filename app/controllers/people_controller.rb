require "csv"

class PeopleController < ApplicationController
  def index
    if params[:name]
      redirect_to person_path(params[:name])
    end
  end

  def show
    @person = Person.new(name: params[:id])

    events = CSV.read(Rails.root.join("data.csv"))
    _headers = events.shift
    events.map! { |event_data| EventBuilder.build(event_data) }

    @events = @person.events_from(events)
  end
end
