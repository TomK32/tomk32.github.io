---
title: One-sided has_and_belongs_to_many relations in Mongoid
date: 2017-03-20
categories: mongoid mongodb
layout: post
---

Are those commonly used anyways? In a relation database you'd do have a `group_members` table where-as
in our app we store the `member_ids` on the `Group`.

```ruby
class Group
  has_and_belongs_to_many :members, class_name: "User", inverse_of: nil, validate: false
end
class User
  def groups
    Group.where(member_ids: self.id)
  end
end
```
