---
title: Google Chart in Ruby
tags:
  - ruby
  - Google Chart
layout: post
date: 2007-12-15
---
Google chart
I stumbled accross (well, let’s say it was on delicious popular) about [gchartrb](http://web.archive.org/web/20071215230031/http://code.google.com/p/gchartrb/) which is a Ruby API for [Google Charts](https://developers.google.com/chart/) and the only place to work it into was my good old ananasblau.de

The examples from the API are quite simple and when I tried to do a chart for the last twenty days I was in big trouble. Here’s my source which uses some rarely used Date methods and by far to many `collect`s. Basically I get my models data, create a hash with date-keys, fill it up, sort it (afterwards it’s an array for some reason) and for the two axis I `collect` and `max` on the array.

```ruby
stats = MyModel.find(:all, :group => 'date', :order => 'created_at ASC',
    :select => ['count(id) as count, DATE_FORMAT(created_at, "%Y-%m-%d") as date'], 
    :conditions => ' created_at > from_unixtime(unix_timestamp() - 3600*24*21)')
  unless stats.empty?
    @dates = {}
    Date.parse(stats[0].date).upto(Date.today()){|d| @dates[d.strftime('%Y-%m-%d')] = 0 }
    stats.collect { |c| @dates[c.date.to_s] = c.count.to_i }
    @dates = @dates.sort{|a,b| a[0] <=> b[0]} # note, it's an array from here on
    #  d[0][8,2] for day only. d[0][5,5] for month and day
    @chart =  GoogleChart::BarChart.new('700x100', "", :vertical, true)
    @chart.axis :x, :labels => @dates.collect{|d| d[0][8,2] }, :alignment => :left
    @chart.axis :y, :range => [0, @dates.max{|a,b| a[1] <=> b[1]}[1]]
    @chart.grid
    @chart.data "", @dates.collect{|d| d[1]}, '55CC88' 
  end
```
