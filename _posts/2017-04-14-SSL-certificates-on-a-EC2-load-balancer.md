---
layout: post
title: SSL certificates on a EC2 loadbalancer
tags:
  - EC2
  - SSL certificates
  - Server
  - DevOP
---

{:.intro}
  If your SSL certificate is a few years old most likely you definitely paid money for it and quite some.
  Thankfully those days are over and we get free certs now. But, your certs are a bit dated like mine and about to run out.
  Here's some tips for you.

At our [hackerspace](http://devlol.org) we run [letsencrypt](https://letsencrypt.org), fully automatic of course, and the only server missing out is an
internal server operating our door lock. hard to get a cert for that but what I've read so far is you give it an external
name lock.devlol.org, add that domain to your letsencryt cert, put it on the internal server and let the internal nameserver
route lock.devlol.org to that internal server. No one's gonna be the wiser.

At Naiku though we have a beefier infrastructure with a loadbalancer and autoscaling. Upto now we had a paid cert installed
on the load balancer and for historic reasons, dating to before the load balancer, also on the app server AMI.
Since then not only Letsencrypt happened, AWS also pulled a rabbit out their hat and called it [AWS Certificate Manager](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html).

How this thing works is you create a cert on the ACM, configure your loadbalancer to use it. Then you can either still have
SSL certs on your instances, or change your loadbalancer's listeners to HTTP.

If you had some small stray app that didn't have a loadbalancer yet you will notice there's not way to download the certificate.
Simply create a load balancer for that application as well and put it into HTTP.
