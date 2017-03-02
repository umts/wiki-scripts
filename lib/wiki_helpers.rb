def category_pages
  wiki = this_wiki
  wiki.pages.select { |page| page.title =~ /^Category:/ }
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

def replace_after_marker(page, content)
  wiki = this_wiki
  combined_content = "#{top_content(page)}\n\n#{seperator}\n\n#{content}\n"

  unless page.raw_data == combined_content
    commit = commit_defaults.merge(message: "Update #{page.name}")
    wiki.update_page(page, page.name, page.format, combined_content, commit)
  end
end

def seperator
  '<!-- +++ -->'
end

def this_wiki
  Gollum::Wiki.new File.expand_path('../..', __FILE__)
end

def top_content(page)
  page.raw_data.split(seperator).first.strip
end
