def category_pages
  this_wiki.pages.select { |page| page.title =~ /^Category:/ }
end

def category_list(pages)
  pages.map do |page|
    "* [[#{page.title}]]"
  end.join("\n")
end

def commit_defaults
  { name:  'Category Bot',
    email: 'noreply@umasstransit.org' }
end

def delete_page(page)
  commit = commit_defaults.merge(message: "Delete #{page.name}")
  this_wiki.delete_page(page, commit)
end

def new_category(page_title, pages)
  commit = commit_defaults.merge(message: "Create #{page_title}")
  content = "\n\n#{seperator}\n\n#{category_list(pages)}"
  this_wiki.write_page(page_title, :markdown, content, commit, 'category-pages')
end

def replace_after_marker(page, content)
  combined_content = "#{top_content(page)}\n\n#{seperator}\n\n#{content}\n"

  unless page.raw_data == combined_content
    commit = commit_defaults.merge(message: "Update #{page.name}")
    this_wiki.update_page(page, page.name, page.format, combined_content, commit)
  end
end

def seperator
  '<!-- +++ -->'
end

def this_wiki
  @this_wiki ||= Gollum::Wiki.new File.expand_path('../..', __FILE__)
end

def top_content(page)
  page.raw_data.split(seperator).first.strip
end
