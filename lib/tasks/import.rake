task :import, [:filename] => [:environment] do |t, args|
  require "csv_importer"
  data_dir = args[:filename]

  puts "Importing: #{data_dir}"

  CsvImporter.new(data_dir).create_records
end
