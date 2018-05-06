---
layout: post
title: "index is nil in a fields_for nested attributes"
tags:
  - rails
  - nested attributes
  - accepts_nested_attributes_for
  - views
date: 2018-05-06
---
Just hit an interesting bug and thankfully fixed it quick enough.

I have a model with entries that I render form fields for and use the `index` for something.
The view looks like this and you get the index for free.

```ruby
= form.fields_for :entries, form.object.entries do |entry_fields|
  = entry_fields.index
  / ...
```

But the index was nil everytime which is contradicing the [documentation on `fields_for`](https://apidock.com/rails/ActionView/Helpers/FormHelper/fields_for).
What I was missing in my model was `accepts_nested_attributes_for :entries` to get the `index` set

```ruby
  class Transaction
    include Mongoid::Document
    embeds_many :entries
    accepts_nested_attributes_for :entries
  end
```
