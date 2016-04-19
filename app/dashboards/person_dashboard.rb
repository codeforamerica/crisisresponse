require "administrate/base_dashboard"

class PersonDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    response_strategies: Field::NestedHasMany.with_options(skip: :person),
    id: Field::Number,
    created_at: Field::DateTime,
    image: Field::Image,
    updated_at: Field::DateTime,
    first_name: Field::String,
    last_name: Field::String,
    name: Field::String,
    sex: Field::String,
    race: Field::String,
    height_in_inches: Field::Number,
    weight_in_pounds: Field::Number,
    hair_color: Field::String,
    eye_color: Field::String,
    date_of_birth: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :response_strategies,
    :id,
    :created_at,
    :updated_at,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :response_strategies,
    :id,
    :created_at,
    :updated_at,
    :first_name,
    :last_name,
    :sex,
    :race,
    :height_in_inches,
    :weight_in_pounds,
    :hair_color,
    :eye_color,
    :date_of_birth,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :response_strategies,
    :first_name,
    :last_name,
    :image,
    :sex,
    :race,
    :height_in_inches,
    :weight_in_pounds,
    :hair_color,
    :eye_color,
    :date_of_birth,
  ]

  # Overwrite this method to customize how people are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(person)
    person.name
  end
end
