class PeopleController < ApplicationController
  RECORDS_PER_PAGE = 12

  before_action :authenticate_officer!

  def index
    @search = Search.new(search_params, Person.visible)
    @search.validate

    @people = @search.
      close_matches.
      includes(:rms_person).
      includes(:images).
      page(params[:page]).
      per(RECORDS_PER_PAGE)
  end

  def show
    @person = Person.includes(:images).find(params[:id])

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
