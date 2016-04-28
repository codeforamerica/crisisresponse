# This file should contain all the record creation
# needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

require "csv_importer"

file = "data.sample/response_plans.csv"
puts "Importing: #{file}"

Officer.destroy_all
ResponsePlan.destroy_all
CsvImporter.new(file).create_records
