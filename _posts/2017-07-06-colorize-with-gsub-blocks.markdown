---
layout: post
title: Colorize with gsub blocks
---

Roughly once a month I put Rails aside and write a little script, in Ruby obviously, and when I do that I love using [colorize](https://github.com/fazibear/colorize) to make my script's output more fancy.

It's `usage` section is full of good examples but there's one I'm using a lot and it's missing from the documentation.
That use-case is when I want to highlight a term in a sentence or paragraph before printing it to the terminal.
[gsub](https://ruby-doc.org/core-2.1.4/String.html#method-i-gsub) has little known overloaded options.
It not only accepts a replacement string (most common use for me) but also an emumerator and interesting for us:
A block in which we can apply out colorization: `puts "A bold programmer".gsub(/(bold)/) {|m| m.bold }`
If you use a regexp for the first argument, make sure to use brackets.

```ruby
require 'open-uri'
require 'nokogiri'
require 'colorize'

host = 'https://www.indiehackers.com'
forum = Nokogiri::HTML(open(host + '/forum'))
interests = Regexp.new('(Show IH|Tips)', :i)

forum.css('a.thread__details').each do |thread|
  title = thread.css('.thread__title').first.inner_text.strip
  if title.match(interests)
    # gsub with a block to highlight the search term
    puts title.gsub(interests) {|m| m.bold }
    puts " -> #{host}#{thread['href']}"
  end
end
```

![Output on my terminal]({{site.url}}/assets/posts/2017-07-06-colorize-with-gsub-blocks.png)

