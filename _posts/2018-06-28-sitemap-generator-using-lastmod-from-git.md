---
title: "sitemap_generator using lastmod date from git repo"
tags:
  - rails
  - sitemap
  - git
---

For my new project [Budgetfuchs](https://budgetfuchs.de) I added [sitemap_generator](https://github.com/kjvarga/sitemap_generator) even though it's just a few pages that I want indexed for now.
But my application is multi-lingual and letting the search engines know about that comes handy.

One thing I noticed when looking at the output was the `lastmod` date being the same for all entries. Can't be hard to fix that by pulling the date from the git repo I though.
Here's the code for this and as you can see, I did monkey-patch `SitemapGenerator::Interpreter`.

```ruby
class SitemapGenerator::Interpreter
  def lastmod(view)
    date = `git log --date iso  -n 1 --format="%ad" app/views/#{view}*`
    if date.blank?
      raise "Missing file #{view}"
    end
    return date
  end
end

SitemapGenerator::Sitemap.create(default_host: 'https://budgetfuchs.de', compress: false, include_root: false) do
  add root_path, changefreq: 'weekly', lastmod: lastmod('welcome/index')
  add team_path, priority: 0.5, lastmod: lastmod('welcome/team')
  add features_de_path, lastmod: lastmod('welcome/features.de.html')
  add features_en_path, lastmod: lastmod('welcome/features.html')
  add pricing_de_path, lastmod: lastmod('purchase/new.de.html')
  add pricing_en_path, lastmod: lastmod('purchase/new.html')
end
```
