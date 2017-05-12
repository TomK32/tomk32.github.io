
---
layout: post
title: Coveralls report in dev environment
date: 2017-05-15
tags: ruby test coveralls
---

To be honest, I'm a simplecov hillbilly. Put an `index.html` into my coverage folder and we can be friends.
Coveralls doesn't, instead it is a pretty webapp; the product owner wants to keep it that way, reports on my
dev machine aren't enough.

But there's a quick solution for me, which I'm starting to like, and that's Coverall's text reporter. It was hard enough to find,
no binstub for it and the Gemfile doesn't load coveralls so it doesn't show up in `rake -T`.
The command I was looking for is `bundle exec coveralls report` and will run the test suite and print me a nice list which sending anything to the internet.

    [Coveralls] Outside the CI environment, not sending data.
    [Coveralls] Some handy coverage stats:
      * app/channels/application_cable/channel.rb => 0%
      * app/channels/application_cable/connection.rb => 0%
      * app/controllers/admin/admin_controller.rb => 100%
      * app/controllers/admin/curators_controller.rb => 81%
      * app/controllers/admin/dashboard_controller.rb => 0%
      * app/controllers/admin/genres_controller.rb => 0%
