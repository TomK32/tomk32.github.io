---
layout: post
title: "ej2 DataManager with Rails"
date: "2019-03-16 19:01:59 +0100"
tags:
  - rails
  - xhr
  - ej2
---
Recently I used [syncfusion's ej2 calendar](https://ej2.syncfusion.com/documentation/calendar/getting-started/) in a small Rails project and
ran into a few problems because Rails is tough on security.

The `UrlAdaptor` that comes with `ej2-data` needs to send our beloved `csrf-token` with all `POST` requests and this is the way I implemented it:


```javascript
    class UrlAdaptorWithCredentials extends UrlAdaptor {
      beforeSend(args: DataManager, xhr: XMLHttpRequest) {
        xhr.withCredentials = true;
        var token = document.querySelector('meta[name="csrf-token"]').content
        xhr.setRequestHeader('X-CSRF-Token', token)
        super.beforeSend(args, xhr);
      }
    }
    data = new DataManager({
      url:       '/calendar',
      crossDomain: true,
      adaptor: new UrlAdaptorWithCredentials()
    });
```

Lastly a general advice on `fetch`: With rails you'll need to send the cookie for `GET` requests and you can do this by adding `{credentials: "include"}` in the options.

```javascript
    fetch('/calendar', {credentials: "include"})
```

