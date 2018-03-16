---
layout: post
title: Copying configurations between AWS ElasticBeanstalk applications
tags:
  - aws
  - beanstalk
date: 2018-02-16
---
We've been happy with AWS AutoScaling for Naiku over the last years, the application
has this interesting behaviour where users are active at a certain, if not precise time
and AutoScaling helps us dealing with sudden spike in requests.
But there are also negative sides to it, using capistrano to deploy on AutoScaling is
possible but if it just switched on/off a server the deployment won't work until that
machine is up. Upgrading the system was a real hardship, ideally with just one server
around, do the upgrade and deploy so that the [elbas](https://github.com/lserman/capistrano-elbas) gem
could create a new image for the next server that launches.
Plenty of chances for some race conditions.

AWS ElasticBeanstalk works differently, packs the app into a zip file, images are standard ones
and it just nicer to work with on many levels.

But ElasticBeanstalk can also be a pain in the arse. Renaming applications or environments? Nope. Not possible.

Using a configuration in another application? Nope. Not poss.. _oh wait what's that in this S3 bucket?_

Indeed, you can copy configurations from one application to the other by simply copying it from
one directory of the S3 bucket into the other app's directory.

So simple, and yet there's no UI for it.

