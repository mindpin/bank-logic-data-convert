require_relative "generate/cdjg_parser.rb"

def path(name)
  File.join Rails.root, 'export', name
end

Dir[path('*.*')].each do |f|
  FileUtils.rm f
end

CdjgParser.prepare_menu_items path('prepared-business-categories.json')
