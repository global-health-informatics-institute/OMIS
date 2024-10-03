require 'holidays'

file_path = File.join(Rails.root, 'config', 'holidays', 'mw.yml')

Holidays.load_custom(file_path)
