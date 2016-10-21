class PeopleController < ApplicationController
  RECORDS_PER_PAGE = 12

  PERSON_ATTRIBUTES = [
    :date_of_birth,
    :eye_color,
    :first_name,
    :hair_color,
    :height_feet,
    :height_inches,
    :id,
    :last_name,
    :location_address,
    :location_name,
    :middle_initial,
    :race,
    :scars_and_marks,
    :sex,
    :weight_in_pounds,
    aliases_attributes: [:_destroy, :id, :name],
    images_attributes: [:_destroy, :id, :source],
  ].freeze

  before_action :authenticate_officer!

  def index
    @search = Search.new(search_params, visible_people)
    @search.validate

    @people = @search.
      close_matches.
      includes(:rms_person).
      includes(:images).
      page(params[:page]).
      per(RECORDS_PER_PAGE)
  end

  def show
    @person = visible_people.includes(:images).find(params[:id])

    PageView.create(officer: current_officer, person: @person)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: t(".success", name: @person.display_name)
    else
      render :new, notice: t(".failure")
    end
  end

  private

  def person_params
    permitted = params.require(:person).permit(PERSON_ATTRIBUTES)
    dob = permitted[:date_of_birth]
    permitted[:date_of_birth] = Date.strptime(dob, "%m-%d-%Y")
    permitted
  end

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

  def visible_people
    if current_officer.admin?
      Person.all
    else
      people_ids = Visibility.where(removed_at: nil).pluck(:person_id)
      Person.where(id: people_ids)
    end
  end
end
