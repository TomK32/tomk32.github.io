---
layout: post
date: 2018-06-01
title: A Ruby DSL in Practise
tags:
  - ruby
  - dsl
  - presentation
---
I did this <a href="{{ 'presentations/de/ruby-dsl' | absolute_url }}">talk on DSLs with focus on Ruby a few days ago, in German</a>, but I figure that interested developers might benefit if I share some more knowledge and the concrete implementation I did for my specific problem.

The software I'm working on is a personal finance web app and to make the sign-up process and first steps as easy as possible I'm using prorammatic templates that I can use to fill out a few forms during sign-up. The users will have several of those templates to choose from.

I shorted the code a little bit in functionality and it's MIT licensed if you want to use it.
dd

Let's start with the data input file, it is Ruby code and extremly easy to read and understand:

```ruby
ledger "Ledger for #{Date.today.year}" do
  unit '€'

  # Looks verbose, but the first it the name, the second argument the type.
  # The app is in German so the name would differ there
  account 'Equity', 'equity'
  account 'Assets', 'assets'
  account 'Expenses', 'expenses'
  account 'Income', 'income'
  account 'Liabilities', 'liabilities'

  transaction 'Bank account' do
    date Date.today
    entry 'Equity:Current', -200
    entry 'Assets:Bank:Current'
  end
  transaction 'Car credit' do
    entry 'Equity:Car', 5000
    entry 'Liabilities:Car'
  end
  recurring_transaction 'Health Insurance', monthly: 3, day_of_month: 15 do
    entry 'Assets:Bank:Current', -1550
    entry 'Expenses:Insurance'
  end
  recurring_transaction 'Job', weekly: 2, day: :tuesday do
    entry 'Income:Job', -2350
    entry 'Assets:Bank:Current'
  end
  recurring_transaction 'Rent', monthly: 1, day_of_month: -2 do
    entry 'Expenses:Living:Rent', 650.23
    entry 'Assets:Bank:Current'
  end
  recurring_transaction 'Envolopes, weekly: 1, day: :monday do
    entry 'Expenses:Food', 40
    entry 'Expenses:Fun', 20
    entry 'Expenses:Other', 30
    entry 'Assets:Bank:Current'
  end
  recurring_transaction 'Savings', monthly: 1, day_of_month: 1 do
    entry 'Assets:Bank:Savings', 75
    entry 'Assets:Bank:Current'
  end
  recurring_transaction 'Ratenkredit', monthly: 1, day_of_month: 1 do
    entry 'Liabilities:Car', 350
    entry 'Assets:Bank:Current'
  end
end
```

And this is the `TemplateProcessor` that handles those input files and processes them into a Ledger with transactions, recurring transactions and accounts. Obviously there are some data models for Ledger, Transaction etc, in my case I'm using MongoId but the DSL is independent of this. My extended version of the `TemplateProcessor` also has a few lines for dry runs where no data is stored.

You can clearly see the `instance_eval` running the inner block for ledger and transaction.

Calls from the input file like `date` and `unit` are passed on to the respective objects via `method_missing`

```ruby
module TemplateProcessor
  def self.process(template, user, ledger = nil)
    dsl = DSL.new
    dsl.user = user
    dsl.ledger = ledger
    dsl.evaluate(template)
  end

  class DSL
    attr_accessor :user
    attr_accessor :ledger
    attr_accessor :ledgers

    def method_missing(method, *args)
      if @transaction && @transaction.respond_to?(method)
        @transaction.send("#{method}=", *args)
        return
      end
      @ledger.send("#{method}=", *args)
    end

    def ledger(name, &block)
      @ledger ||= Ledger.new(name: name)
      @ledger.ledger_roles.new(creator: user, user: user)
      @ledger.save!
      instance_eval(&block)
      @ledgers ||= []
      @ledgers.push @ledger
      @ledger = nil
    end
    expose :ledger

    def account(name, account_type)
      account = @ledger.accounts.new(name: name, account_type: account_type)
      account.save!
    end

    def transaction(description, &block)
      @transaction = @ledger.transactions.new(description: description)
      @transaction.date = Date.today
      @amount = 0
      instance_eval(&block)
      @transaction.save!
      @transaction = nil
    end
    expose :transaction

    def entry(account_name, amount = nil)
      if amount.nil?
        amount = - @amount
        @amount = 0
      else
        @amount += amount
      end
      @transaction.entries.new(account_name: account_name, amount: amount)
    end
    expose :entry

    def recurring_transaction(description, rule, &block)
      @transaction = @ledger.recurring_transactions.new(description: description)
      @transaction.rule = IceCube::Rule
      rule.each_pair do |method, args|
        @transaction.rule = @transaction.rule.send(method, *args)
      end
      @amount = 0
      instance_eval(&block)
      @transaction.save!
      @transaction = nil
    end
    expose :recurring_transaction
  end
end
```
