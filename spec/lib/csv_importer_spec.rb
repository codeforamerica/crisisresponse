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
      plan = create(:response_plan, names)
      token = plan.analytics_token
      importer = CsvImporter.new("data.sample")

      importer.create_records

      new_plans = ResponsePlan.where(names)
      expect(new_plans.count).to eq(1)
      expect(new_plans.first.analytics_token).to eq(token)
    end

    it "updates the information" do
      names = { first_name: "Martha", last_name: "Tannen" }
      plan = create(:response_plan, names.merge(sex: "Male"))
      importer = CsvImporter.new("data.sample")

      importer.create_records

      plan.reload
      expect(plan.sex).to eq("Female")
    end
  end
end
