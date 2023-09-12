---
title: Bitbucket pipeline with an elasticsearch server
tags:
    - bitbucket
    - pipeline
    - elasticsearch
---
This week I'm setting up a [bitbucket pipeline](https://bitbucket.org/product/de/features/pipelines) for a Ruby on Rails app that uses a few services, among them elastic search.
Now starting that service throws up an error as elasticsearch servers are social animals and really like to connect to other elasticsearch servers and you'll see this erro in the log/tab for the elasticsearch server:
```
the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
```

The error doesn't provide the answer or rather configuration you need as it is `discovery.type=single-node` what you want to use. I also use that option in the `docker-compose.yml` for local development on that app.

Simple you think, just add this to the `bitbucket-pipelines.yml`? Not quite because if you do this is the error you get from bitbucket pipelines and on top of that, bitbucket's own validator is just fine with it. Yeah, I guess there's two different pieces of code for the yml file...

```
There is an error in your bitbucket-pipelines.yml at [definitions > services > elasticsearch]. The variable name "discovery.type" is invalid. It should contain only alphanumeric characters and underscores and it should not begin with a number.
```

After quite some research a [stackoverflow answer](https://stackoverflow.com/a/70289927/336392) pointed me into the right direction, [elasticsearch has become more flexible about their configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-configuration-methods),
starting with version 7.15 (I have to run 7.17, lucky me) and you can substitute `discovery.type` with `ES_SETTING_DISCOVERY_TYPE` giving you the following `bitbucket-pipelines.yml`:

```
definitions:
  services:
    elasticsearch:
      image: elasticsearch:7.17.6
      variables:
        ES_SETTING_DISCOVERY_TYPE: single-node
```
