---
layout: post
title: Print the indexes of all your mongodb collections
tags:
  - mongodb
date: 2018-03-16
---
As it happens I tend to try out indexes on the production or staging MongoDB first before adding them to the codebase.
While this might not be the proper way, it's the production db that has all that precious data that we
work on and thus is the one that will be slow if we don't add the correct indexes.

Doing this might sometimes lead to forgetting to add an index to the codebase, or not removing an index that
didn't get picked up by the code as intended.

So we need a way to print out our indexes in one nice and compact list. Of course you can do this on the mongo console,
but I'm a ruby dev and a nice rake task in my code-repo is the best thing I can think of.

Here it is for everyone. Mind you it doesn't print out text indexes correctly.

```ruby
namespace :mongo do
  desc 'Prints out the indexes in all collections'
  task :print_indexes do
    collections = Mongoid.client('default').database.collections
    collections.each do |collection|
      puts collection.name
      puts collection.indexes.collect{|index| [index['key'], {sparse: index['sparse'], background: index['background']}].join(', ') }.join("\n")
    end
  end
end
```
