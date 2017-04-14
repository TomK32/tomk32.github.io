---
title: mongoid_taggable with aggregation for Mongoid 5
tags: mongoid gem
layout: post
date: 2017-03-23
---

Turned out that my [migration earlier this week]({% post_url 2017-03-22-migrate-from-moped-to-mongo %}) ran into a few bumps with `mongoid_taggable`.
The big thing the previous used version from colibri-software used was the aggregation framework which in the case of generating the
tags index is far superior to the `map_reduce` of the older versions. The mongoid 5 compatible version I picked as a replacement didn't
use the aggregation framework, caused me headache and I decided to
[upgrade colibri's version](https://github.com/TomK32/mongoid_taggable/commit/737d8bfc68fd4bf000aac0488bc88a9260cd6f60). Nothing
special there, just remember that you need to append a `.to_a` if you pass a `$out` stage to `aggregate()`.

```ruby
MyThings.collection.aggregate([
  {"$unwind" => "$tags_array"},
  {"$group" => {"_id" => "$tags_array}},
  {"$project" => {"tags_array: 1}},
  {"$out" => "things_tags"}
]).to_a  # don't rmeove the to_a or the things_tags collection will be empty
```
