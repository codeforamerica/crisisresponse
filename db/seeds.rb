# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Contact.destroy_all
ResponseStrategy.destroy_all
SafetyWarning.destroy_all

Person.destroy_all

person = Person.create(
  name: "John Doe",
  image: File.open(Rails.root + "spec/fixtures/image.jpg"),
  sex: "Male",
  race: "AFRICAN AMERICAN/BLACK",
  height_in_inches: 70,
  weight_in_pounds: 180,
  hair_color: "Black",
  eye_color: "Brown",
  date_of_birth: Date.new(1980, 01, 02),
  scars_and_marks: "Skull tattoo on neck",
)

ResponseStrategy.create(
  person: person,
  title: "Call case manager",
  description: "The case manager usually can calm John down over the phone",
  priority: 1,
)

ResponseStrategy.create(
  person: person,
  title: "Send to DESC",
  description: "John knows the staff at DESC, and they may be able to help",
  priority: 2,
)

Contact.create(
  person: person,
  name: "Jane Doe",
  relationship: "Sister",
  cell: "222-333-4444",
  notes: "Lives in Bellevue",
)

Contact.create(
  person: person,
  name: "Mark Johnson",
  relationship: "Case worker",
  cell: "333-444-5555",
  notes: "Available from 9am - 5pm",
)

SafetyWarning.create(
  person: person,
  description: "owns a gun",
)

SafetyWarning.create(
  person: person,
  description: "has previously possessed needles",
)
