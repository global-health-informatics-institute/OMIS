file_path = File.join(Rails.root, 'config', 'holidays', 'mw.yml')
puts "loading custom holidays from #{file_path}"
#puts File.read(file_path)
Holidays.load_custom(file_path)
