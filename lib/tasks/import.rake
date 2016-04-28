
task :import, [:filename] => [:environment] do |t, args|
  require "csv_importer"
  file = args[:filename]

  puts "Importing: #{file}"

  ResponsePlan.destroy_all
  CsvImporter.new(file).create_records
end
