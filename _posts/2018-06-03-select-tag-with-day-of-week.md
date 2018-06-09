---
title: "Rails: Select tag with day of the week"
tags:
  - rails
  - i18n
---
Some things are really super simple and suprise me even after a decade working with rails.

How about this `select_tag`, i18n, for weekdays? With the value being a 0 to 6.

    select_tag 'day_of_week', I18n.t('date.day_names').zip(0..6)

[`Array#Zip`](https://ruby-doc.org/core/Array.html#method-i-zip) is one of those methods used far too little in practise.
