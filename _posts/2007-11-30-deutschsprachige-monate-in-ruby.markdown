---
title: Deutschsprachige Monate in Ruby
tags: ruby i18n
layout: post
date: 2007-11-30
---
Nicht gerade neu der Tipp, aber ich brauchte einfach nur die deutschen (bzw. österreichischen) Monatsnamen und schneller als so kann’s nicht gehen:

```ruby
Date::MONTHNAMES = [nil] + %w(Jänner Feber März April Mai Juni Juli \
August September Oktober November Dezember)
```

Das ist doch immer wieder das Schöne an Ruby, nur weil’s ne Klasse oder eine Konstante ist heißt das nicht dass man nicht hinterher nochmal was dran ändern könnte. Einfach herrlich bequem.
