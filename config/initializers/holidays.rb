file_path = File.join(Rails.root, 'config', 'holidays', 'mw.yml')

if File.file?(file_path)
  Holidays.load_custom(file_path)
end
