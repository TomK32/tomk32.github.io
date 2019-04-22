---
layout: post
title: "Pundit with inherited resources"
date: "2019-04-22"
tags:
  - inherited_resources
  - pundit
---
Call be old-fashioned and out-dated, but I'm still a huge fan of [`inherited_resources`](https://github.com/activeadmin/inherited_resources/) and
of ourse I'm using it in my latest project which will be about checklists.

I also added `pundit` and `pundit_extra` to the project and when using the latter you'll run into some
conflict with `inherited_resources` method `resource`. The `load_resource` from `pundit_extra`
ultimately uses `instance_variable_get "@#{resource_name}"` to get the resource and so I just did a simple alias.

```ruby
  alias :resource_instance :resource
```

Not that if you do overwrite `resource` in your controller, make sure to set the alias after that method.

