namespace :wiki do
  desc 'Build the category pages and update the Home page'
  task categories: 'wiki:categories:default'

  namespace :categories do
    task :default do
      Rake::Task['wiki:categories:build'].invoke
      Rake::Task['wiki:categories:index'].invoke
    end

    desc 'Build the pages for all required categories. Remove unneeded ones.'
    task build: 'wiki:setup' do
      categories = Hash.new { |h, k| h[k] = [] }
      wiki = this_wiki

      wiki.pages.each do |page|
        next unless page.metadata && page.metadata['tags']
        tags = YAML.load(page.metadata['tags'])
        tags.each do |tag|
          categories[tag] << page
        end
      end

      categories.each do |category, pages|
        page_title = "Category: #{category.capitalize}"
        category_page = wiki.page(page_title)

        if category_page
          replace_after_marker category_page, category_list(pages)
        else
          new_category page_title, pages
        end
      end

      category_pages.each do |page|
        category_name = page.name.sub(/^Category: /, '').downcase
        next if categories.key?(category_name)
        if top_content(page).blank?
          delete_page page
        else
          replace_after_marker page, nil
        end
      end
    end

    desc 'Update the "Home" page with a list of all of the current categories'
    task :index do
      wiki = this_wiki
      index_page = wiki.page('Home')
      replace_after_marker index_page, category_list(category_pages)
    end
  end
end
