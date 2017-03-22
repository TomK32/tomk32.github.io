---
title:  "Migrate from Moped to the ruby mongo driver"
date:   2017-03-22 13:24:53 +0100
categories: moped mongoid mongodb 
---
It clearly has been some time since Mongoid 5 has been released,
yes there's even Mongoid 6 but as our app still runs on Rails 4.x that's not an option yet.
Plus the big works is in Moped -> Mongo anyways.
The main reason why I'm doing this, the failure handling in Moped for
when one for my replica nodes fails is shit. Plain as that,
the app's performance slumps immediately when one node fails and that's never acceptable.

So, here's some stuff do you have to check for when upgrading, besides the [https://docs.mongodb.com/ruby-driver/master/tutorials/5.2.0/mongoid-upgrade/](very few things mentioned in the official docs) of course. You will also find the [http://www.rubydoc.info/github/mongodb/mongoid](API docs) most helpful.

As usual: Having a lot of tests will help you, **write specs**. I can't repeat it often enough. In our case only 5% failed after updating the gem, I expected more in this 6+ yrs old application but a few commits later I saw the green light as a wiser man.

## Your gemfile

I bet you know what to do, but for those new to bundler and the ruby-sphere:

```ruby
gem 'mongoid', '~> 4.0'
gem 'mongoid', '~> 5.0'
```

## Querying by ids requires `BSON::ObjectId.from_string`

Given this little model
```ruby
class Favourite
  include Mongoid::Document
  belongs_to :user
  belongs_to :f, :polymorphic => true, :validate => false # add f_type and f_id fields
end
```

With the upgrade the error was actually hard to spot, lot of document not found before I realized
that I was passing the id as a string and not as an ObjectId (MongoDB's internal format to store them, back in the days you could use strings if you really wanted).

In my controller I did query for favs based on the information what it is favouring, this line won't do anymore
`current_user.favourites.where(f_type: params[:f_type], f_id: params[:f_id]).first`

and that needed an explicit `BSON::ObjectId.from_string`.

`current_user.favourites.where(f_type: params[:f_type], f_id: BSON::ObjectId.from_string(params[:f_id])).first`
  
An even **better solution**, and closing security holes for most cases, would be to pass the favourited object and let mongoid do its magic.

`current_user.favourites.where(f: MyThing.find(params[:f_id])).first`

## no implicit conversion of Mongo::Collection::View::Aggregation into Array

Hit this error when concating (concatting?) an aggregation to an array.

```ruby
items.concat Thing.collection.aggregate([
        {"$match" => selector},
        {"$sample" => {size: size}},
        {"$project" => {_id: 1, text: 1}}
     ])
```
and a simple `to_a` on it did fix it: `Thing.collection.aggregate(...).to_a`

Over are the days where we could just slap stuff together and let moped figure that it's all arrays.

## Map reduce with inline collections

The error message was along the lines of `Invalid collection name things_test (73)` and it took me some
time to figure that I used `map_reduce(map, reduce).out(inline: true)` and mongodb now explicitly wants
to see `inline: 1`. Ok... *still friends*?

## `includes()` can be picky about the order of relations

Something that I used in only one place, but `includes` will raise a `NoMethodError` if it disagrees
with your order. Something like `User.includes(:country, :town)` (Town belongs to Country) didn't work but `User.includes(:town, :country)` did. Beats me. Just change the order and move on.

## gems

Everyone's Gemfile is different, we have 10 mongoid gems in use, here's the troublemakers.

### mongoid_taggable

Now this is a old gem, left outside by it's original developer and quite a few people took it
home and prepped it for yet another version of mongoid. We were using the version from [https://github.com/colibri-software/mongoid_taggable](colibri-software)
through-out mongoid 4 but no mongoid 5 yet and I didn't need those few extra functions anyways.
We'll see if the one from [https://github.com/astjohn/mongoid_taggable/tree/mongoid5](Adam) will stick.


