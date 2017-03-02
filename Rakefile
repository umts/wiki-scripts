require 'bundler'
require 'yaml'
Bundler.require
require_relative 'lib/wiki_helpers'

namespace :wiki do
  directory 'category-pages'
  task setup: 'category-pages'

  task categories: 'wiki:categories:default'

  namespace :categories do
    task :default do
      Rake::Task['wiki:categories:build'].invoke
      Rake::Task['wiki:categories:index'].invoke
    end

    task build: 'wiki:setup' do
      categories = Hash.new{ |h, k| h[k] = [] }
      wiki = this_wiki

      wiki.pages.each do |page|
        if page.metadata && page.metadata['tags']
          tags = YAML.load(page.metadata['tags'])
          tags.each do |tag|
            categories[tag] << page
          end
        end
      end

      categories.each do |category, pages|
        page_title = "Category: #{category.capitalize}"
        category_page = wiki.page(page_title)

        if category_page
          replace_after_marker category_page, category_list(pages)
        else
          commit = commit_defaults.merge({ message: "Create #{page_title}" })
          content = "\n\n#{seperator}\n\n" + category_list(pages)
          wiki.write_page(page_title, :markdown, content, commit, 'category-pages')
        end
      end

      category_pages.each do |page|
        category_name = page.name.sub(/^Category: /, '').downcase
        unless categories.has_key?(category_name)
          if top_content(page).blank?
            commit = commit_defaults.merge({ message: "Delete #{page.name}" })
            wiki.delete_page(page, commit)
          else
            replace_after_marker page, nil
          end
        end
      end
    end

    task :index do
      wiki = this_wiki
      index_page = wiki.page('Home')
      replace_after_marker index_page, category_list(category_pages)
    end
  end
end