class PeopleController < ApplicationController
  RECORDS_PER_PAGE = 12

  before_action :authenticate_officer!

  def index
    if current_officer.can_view_people_without_response_plans?
      @search = Search.new(search_params)
    else
      plans = current_officer.admin? ? ResponsePlan : ResponsePlan.where.not(approved_at: nil)
      people_with_response_plans = Person.where(id: plans.pluck(:person_id).uniq)
      @search = Search.new(search_params, people_with_response_plans)
    end

    @search.validate

    @people = @search.
      close_matches.
      includes(:rms_person).
      includes(:images).
      page(params[:page]).
      per(RECORDS_PER_PAGE)

    @response_plans = @people.map do |person|
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
      person.response_plans.order(:approved_at).last ||
        person.response_plans.last
    else
      person.active_response_plan
    end
  end
end
