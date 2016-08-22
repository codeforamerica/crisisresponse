class PeopleController < ApplicationController
  before_action :authenticate_officer!

  def index
    @search = Search.new(search_params)
    @search.validate
    people = @search.close_matches

    if current_officer.can_view_people_without_response_plans?
      people_with_visible_plans = people
    else
      people_with_visible_plans = people.select do |person|
        visible_plan_for(person)
      end
    end

    @response_plans = people_with_visible_plans.map do |person|
      [person, visible_plan_for(person)]
    end.to_h
  end

  def show
    @person = Person.find(params[:id])
    @response_plan = visible_plan_for(@person)

    PageView.create(officer: current_officer, person: @person)
  end

  private

  def search_params
    if params[:search].present?
      params.require(:search).permit(
        :name,
        :date_of_birth,
        :age,
        :height_feet,
        :height_inches,
        :weight_in_pounds,
        eye_color: [],
        hair_color: [],
        race: [],
        sex: [],
      )
    else
      {}
    end
  end

  def visible_plan_for(person)
    if current_officer.admin?
      person.response_plans.order(:approved_at).last
    else
      person.active_response_plan
    end
  end
end
