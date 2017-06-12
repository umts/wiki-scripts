namespace :wiki do
  desc 'Check image links and insert tags for wiki images'
  task images: 'wiki:images:default'

  namespace :images do
    task :default do
      Rake::Task['wiki:images:check'].invoke
      Rake::Task['wiki:images:replace'].invoke
    end

    desc 'Check image tags for missing files'
    task check: :setup do
      this_wiki.pages.each do |page|
        page.raw_data.scan(image_pattern) do
          filename = 'wiki-images/' + $~['filename']
          next if File.file? filename
          STDERR.puts "File, #{ filename.red } does not exist"
        end
      end
    end

    desc 'Insert image tags for wiki images'
    task :replace do
      this_wiki.pages.each do |page|
        page_content = page.raw_data.gsub(image_pattern) do
          "![#{ $~['alt'] }](#{ image_url $~['filename'] })"
        end
        next unless $~
        commit = commit_defaults.merge(message: "Construct image links in #{page.name}")
        this_wiki.update_page(page, page.name, page.format, page_content, commit)
      end
    end
  end
end
