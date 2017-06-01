namespace :wiki do
  desc 'Insert image tags for wiki images'
  task images: 'wiki:images:default'

  namespace :images do
    task :default do
      this_wiki.pages.each do |page|
        page_content = page.raw_content.gsub(image_pattern, "![\\k<alt>](#{image_url $~[filename]})")
        next unless $~
        commit = commit_defaults.merge(message: "Construct image links in #{page.name}")
        this_wiki.update_page(page, page.name, fage.format, page_content, commit)
      end
    end
  end
end
