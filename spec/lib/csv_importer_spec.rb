require "rails_helper"
require "csv_importer"

describe CsvImporter do
  context "When a response plan does not exist" do
    it "creates a response plan" do
      importer = CsvImporter.new("data.sample")

      expect { importer.create_records }.to change(ResponsePlan, :count).by(3)
    end
  end

  context "When a response plan already exists with the same name" do
    it "does not overwrite its analytics token" do
      names = { first_name: "Martha", last_name: "Tannen" }
      person = create(:person, names)
      plan = create(:response_plan, person: person)
      token = plan.person.analytics_token

      CsvImporter.new("data.sample").create_records

      person = Person.where(names)
      new_plans = ResponsePlan.where(person: person)
      expect(new_plans.count).to eq(1)
      expect(new_plans.first.person.analytics_token).to eq(token)
    end

    it "updates the information" do
      names = { first_name: "Martha", last_name: "Tannen" }
      person = create(:person, names.merge(sex: "Male"))
      plan = create(:response_plan, person: person)

      CsvImporter.new("data.sample").create_records

      plan.reload
      expect(plan.person.sex).to eq("Female")
    end
  end

  it "imports multiple images" do
    CsvImporter.new("data.sample").create_records

    person = Person.find_by(first_name: "Martha", last_name: "Tannen")
    plan = ResponsePlan.find_by(person: person)
    expect(plan.images.count).to eq(2)
  end
end
