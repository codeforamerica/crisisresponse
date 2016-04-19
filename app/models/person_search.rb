class PersonSearch
  include ActiveModel::Model

  attr_accessor :name, :date_of_birth

  def close_matches
    people = Person

    if name.present?
      people = people.search(name)
    end

    if date_of_birth.present?
      people = people.where(date_of_birth: date_of_birth_range)
    end

    people.all
  end

  private

  def date_of_birth_range
    (parsed_date_of_birth - 1.year)..(parsed_date_of_birth + 1.year)
  end

  def parsed_date_of_birth
    Chronic.parse(date_of_birth)
  end
end
