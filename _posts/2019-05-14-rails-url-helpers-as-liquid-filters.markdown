---
layout: post
title: "Rails url helpers as liquid filters"
date: "2019-05-14"
tags:
  - rails
  - liquid
  - filters
---

For a new personal project, [Checklistenguru.de](https://checklistenguru.de?utm_source=tomk32.de&utm_campgaign=guru) I wanted to use `liquid` for the longish description texts that get filled with
links to other pages inside the app. Naturally the usual url helpers get used and I had to come up with a way to use them.

I got the inspiration from [Philippe Bourgau](https://philippe.bourgau.net/including-railsapplicationroutesurlhelpers-fr/) and the following lines will allow you to use any named route **_path** in a
liquid filter, e.g. `{% raw %}{{"moon-trip" | public_template_list_path }}{% endraw %}`. If you also set the `default_url_options` you will be able to use the **_url** helpers as well.

```ruby
# app/helpers/link_helper.rb
# yes, not in the initializers but the helpers

module LinkFilter
  include Rails.application.routes.url_helpers
  def default_url_options
    {}
  end
end

Liquid::Template.register_filter(LinkFilter)
```
