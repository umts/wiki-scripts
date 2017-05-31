namespace :wiki do
  desc 'Insert image tags for wiki images'
  task images: 'wiki:images:default'

  namespace :images do
    task :default do
      #Rake::Task['wiki:images:something'].invoke
      this_wiki.pages.each do |page|

      end
    end
  end
end
