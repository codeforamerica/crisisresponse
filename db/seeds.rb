# This file should contain all the record creation
# needed to seed the database with its default values.
# The data can then be loaded with `rake db:seed`
# (or created alongside the db with db:setup).

require "csv_importer"

data_dir = "data.sample"
puts "Importing: #{data_dir}"

Officer.destroy_all
ResponsePlan.destroy_all
CsvImporter.new(data_dir).create_records
