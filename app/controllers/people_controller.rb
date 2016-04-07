require "csv"
require "net/http"
require "rms_adapter"

class PeopleController < ApplicationController
  def index
    if params[:name]
      redirect_to person_path(params[:name])
    end

    @people = all_people_with_event_counts
  end

  def latest
    csv_url = ENV.fetch("GOOGLE_FORM_CSV_URL")
    uri = URI(csv_url)
    form_data = Net::HTTP.get(uri)
    plans_data = CSV.parse(form_data, headers: true)
    plan = ResponsePlanBuilder.build(plans_data.first)
    redirect_to person_path(plan.name)
  end

  def show
    first_name, last_name = params[:id].split
    @person = Person.find_by(first_name: first_name, last_name: last_name)
    @events = events_for(@person)

    @plan = find_most_recent_plan_for_person(@person)

    if @events.none?
      redirect_to :people, alert: "Could not find any records for #{@person.name}"
    end
  end

  private

  def all_people_with_event_counts
    names = RMSAdapter.new.events.map do |event|
      [event.crisis_contacted_first_name, event.crisis_contacted_last_name]
    end

    name_counts = names.group_by { |x| x }.transform_values { |v| v.count }
    name_counts = name_counts.sort_by { |name, count| -count }.to_h

    name_counts.transform_keys! do |name|
      Person.new(first_name: name.first, last_name: name.last)
    end
  end

  def events_for(person)
    rms = RMSAdapter.new
    rms.events_for(person)
  end

  def find_most_recent_plan_for_person(person)
    ResponsePlanBuilder.build({})
  end
end
