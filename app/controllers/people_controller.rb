class PeopleController < ApplicationController
  RECORDS_PER_PAGE = 12

  before_action :authenticate_officer!

  def index
    if current_officer.can_view_people_without_response_plans?
      @search = Search.new(search_params)
    else
      plans = ResponsePlan.where.not(approved_at: nil)
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
      [person, person.active_plan]
    end.to_h
  end

  def show
    @person = Person.find(params[:id])
    @response_plan = @person.active_plan

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
end
