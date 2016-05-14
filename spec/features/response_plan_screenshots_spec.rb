require "rails_helper"
require "csv_importer"

feature "visit all plans", :js do
  def data_dir
    "data.sample"
  end

  scenario "in day mode" do
    sign_in_officer
    CsvImporter.new(data_dir).create_records
    dir = Rails.root.join("screenshots", "day")
    FileUtils.mkdir_p(dir)

    ResponsePlan.all.each do |plan|
      visit response_plan_path(plan)
      filename = "#{plan.last_name.downcase}_#{plan.first_name.downcase}.png"
      page.save_screenshot(dir.join(filename))
    end
  end

  scenario "in night mode" do
    sign_in_officer
    CsvImporter.new(data_dir).create_records
    dir = Rails.root.join("screenshots", "night")
    FileUtils.mkdir_p(dir)

    visit response_plans_path
    find(".menu-icon").click
    click_on "Light/Dark"

    ResponsePlan.all.each do |plan|
      visit response_plan_path(plan)
      filename = "#{plan.last_name.downcase}_#{plan.first_name.downcase}.png"
      page.save_screenshot(dir.join(filename))
    end
  end
end
