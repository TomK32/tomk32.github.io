---
layout: post
title: "Rspec: Shared context for DRY controller tests"
tags:
  - rails
  - rspec
---

Best if I start with a confession: The number of shared context or share examples that I have in my spec is a low digit.
No idea why I missed that trend, but with budget-fox.com I promise to do better and cut down on repetition in my specs.

If your controller specs are a bit like mine they might look like this:

```ruby
  # ...
  let(:user) { Fabricate(:user) }
  before do
    sign_in user, scope: :user
  end
  # ...
```

That's actually pretty slim but with this very same pattern repeated over a few dozen controller there's something in rspec-core that's useful: [shared
context](https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-context)

If you repeat the same `let` and `before` calls over and over again, it's best to put them into your `spec/support` folder, in my case in `sign_in_context.rb`. The context is then included from the controller spec.

```ruby
# only argument is:
# scope (defaults to :user)
RSpec.shared_context "sign in user", :shared_context => :metadata do |args|
  signed_in_scope = args.fetch(:model, :user)
  let(signed_in_scope) do
    Fabricate(signed_in_scope)
  end
  before :each do |c, a|
    sign_in self.send(signed_in_scope.to_sym), scope: signed_in_scope
  end
end
```

And in the controller spec:

```ruby
RSpec.describe Admin::UsersController, type: :controller do
  include_context 'sign in user', model: :admin
  it "GET #index" do
    # ...
  end
end
```
