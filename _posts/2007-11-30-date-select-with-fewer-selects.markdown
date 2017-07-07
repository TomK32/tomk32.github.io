---
layout: post
title: date_select with fewer selects
tags:
  - rails
date: 2007-11-30
---
`date_select` is sure an useful helper in when building forms, but sometimes you don’t want the year to be a select but a text input for practical reasons or for typing in the dates of ancient philosophers.
My first idea was to overwrite `date_or_time_select` which is called by date_select but why not a step further? Instead of `select_year` giving me a select box I’ll get a text input working just like the select. Put the code lines into your application helper file or into a new file in your lib. I’m not exactly sure how to have both variations in one app, any hints are welcome.

```ruby
module ActionView
  module Helpers
    class InstanceTag
      def select_year(date, options = {})
        val = date ? (date.kind_of?(Fixnum) ? date : date.year) : ''
        if options[:use_hidden]
          hidden_html(options[:field_name] || 'year', val, options)
        else
          name = options[:field_name] || 'year'
          tag :input, { "type" => "text", "name" => name, "id" => name, "value" => val, :size => 4 }
        end
      end
    end
  end
end
```
