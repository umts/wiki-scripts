require 'bundler'
require 'yaml'
Bundler.require
require_relative 'lib/wiki_helpers'

desc 'Run all wiki tasks'
task wiki: 'wiki:default'

namespace :wiki do
  directory 'category-pages'
  directory 'images'

  desc 'Create required files and directories'
  task setup: ['category-pages', 'images']

  task default: :setup do
    Rake::Task['wiki:categories'].invoke
    Rake::Task['wiki:images'].invoke
  end
end

Dir.glob('tasks/*.rake').each{ |r| import r }
