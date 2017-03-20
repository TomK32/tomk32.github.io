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

So, what stuff do you have to do for this upgrade, besides the [https://docs.mongodb.com/ruby-driver/master/tutorials/5.2.0/mongoid-upgrade/](very few things mentioned in the official docs)

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
  belongs_to :f, :polymorphic => true, :validate => false # can be anything favourable
end
```

And in my controller I did query for favs based on the information what it is favouring, this line won't do anymore
`current_user.favourites.where(f_type: params[:f_type], f_id: params[:f_id]).first`

and needed an explicit `BSON::ObjectId.from_string`.

`current_user.favourites.where(f_type: params[:f_type], f_id: BSON::ObjectId.from_string(params[:f_id])).first`
  
An even better solution, and closing security holes for most cases, would be to pass the favourited object and not just type and id.

`current_user.favourites.where(f: MyThing.find(params[:f_id])).first`

