---
layout: post
title: Serving static jekyll websites
tags:
  - jekyll
  - nginx
---
It's been some time since I've done anything with this blog, but after reactivating my old tomk32.de
I had to move it because my dns won't allow me an A-record for the root domain, so hosting it on
github.io wasn't possible.
I also wanted some extra features, there's an [awesome list of jekyll plugins](https://github.com/planetjekyll/awesome-jekyll-plugins) to dig through.

Here's a few useful links:

* [https://gist.github.com/bennylope/1894706#gistcomment-734347](Canonical URLs for jekyll websites)
* [https://letsencrypt.org/](Let's Encrypt), didn't have to do anything special here as my server was already set up properly. A `certbot run -d tomk32.de` did the works.
* [https://linuxacademy.com/blog/linuxacademy-com/wildcard-certificates-with-lets-encrypt-and-nginx/](Wild-cards with let's encrypt) because in the past I did use a few subdomains and I want to combine them all
* [https://jch.penibelst.de/](compress.html) layout for jekyll resulted in much more readable HTML output
* [https://jekyllrb.com/docs/configuration/front-matter-defaults/](Jekyll's frontmatter defaults) because in the past I've often forgot to add the `layout` to a new post
* [https://david.elbe.me/jekyll/2015/06/20/how-to-link-to-next-and-previous-post-with-jekyll.html](Link next/previous post) just for some more internal links
* In the end I used random posts instead of related ones, but you must [https://footle.org/2014/11/06/speeding-up-jekylls-lsi/](speed up lsi with the help of gsl)
