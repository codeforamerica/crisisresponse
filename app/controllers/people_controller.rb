require "csv"

class PeopleController < ApplicationController
  def index
    if params[:name]
      redirect_to person_path(params[:name])
    end
  end

  def show
    @name = params[:id]

    first, last = @name.split

    @events = CSV.read(Rails.root.join("data.csv"))
    @headers = @events.shift
    @events.map! { |event_data| EventBuilder.build(event_data) }

    @events.select! do |event|
      event.crisis_contacted_first_name.downcase == first.downcase &&
        event.crisis_contacted_last_name.downcase == last.downcase
    end
  end
end
