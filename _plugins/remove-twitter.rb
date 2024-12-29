Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |content|
  content.output.gsub!(/<meta.*"twitter.*>\n/, '')
end

