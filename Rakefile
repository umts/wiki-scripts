require 'bundler'
require 'yaml'
Bundler.require
require_relative 'lib/wiki_helpers'

namespace :wiki do
  directory 'category-pages'
  directory 'images'
  task setup: ['category-pages', 'images']
end

Dir.glob('tasks/*.rake').each{ |r| import r }
