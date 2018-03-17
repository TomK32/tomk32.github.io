---
layout: post
title: "Rails on Elasticbeanstalk: caching assets for deployment"
tags:
  - ruby on rails
  - AWS
  - Elasticbeanstalk
date: 2018-03-18
---

Our Elasticbeanstalk adventure continues and one main task was to get deployment times down.
Vanilla it did take way more than 10 minutes: 200 gems and quite a few js/css libs (incl. compass)
did slow it down that much.

The previous setup with just AutoScaling kept the app on basically the same
instances/AMI and especially the asset cache kicked in every time without me even remember that was a thing.

Elasticbeanstalk is a bit different, you won't have the asset cache automatically. Thankfully [Sebastian wrote a little
ebextension](http://sebastien.saunier.me/blog/2017/12/02/speed-up-the-aws-elastic-beanstalk-deployment-of-a-ruby-on-rails-application.html) to rectify this and speed up deployment. But quickly I ran
into the same problem: when the scaling launched a new instance this instance still took ages to deploy. Sebianstan's extension didn't cover that but luckily we can simple use S3 (where we have a
bucket anyways for the appdeploy) to copy a gzipped asset file to and from:

```
      if aws s3 ls s3://elasticbeanstalk-my-region-my-accountid/cache/assets.tar.gz ; then
        aws s3 cp --quiet "$(/opt/elasticbeanstalk/bin/s3-assets-cache.sh)" /tmp/assets.tar.gz
        [ -f /tmp/assets.tar.gz ] && tar -xf /tmp/assets.tar.gz -C $EB_APP_STAGING_DIR \
          && chown webapp:webapp -R "$EB_APP_STAGING_DIR/tmp"
      fi
```

and when we build the cache we store the file to S3:

```
      tar -zcf /tmp/cache/assets.tar.gz       tmp/cache/assets
      aws s3 cp /tmp/assets.tar.gz s3://elasticbeanstalk-my-region-my-accountid/cache/assets.tar.gz
```

Done. Well, fo rmost of you, but I'm not there yet.
As I had to find out the hard way, we have one js gem (tinymce) that insists on copying the `ASSET_HOST` into the js output. 
Usually not a problem, but we have different assets hosts for different copies of the application, mostly for test purposes
or keeping bigger features available for testing.
We just rename the `assets.tar.gz` file to `assets-my-environment.tar.gz`, right? Yes, and to get that tiny big of information about the environment's name you have to setup a policy for the IAM role
and query via aws... This [gist by Melvin](https://gist.github.com/SteelPangolin/08880dc2c74b9c26cb5b#gistcomment-2371351) did the trick for me, so much I put it into its own file that gets created
from the ebextension:

```
  "/opt/elasticbeanstalk/bin/s3-assets-cache.sh":
    mode: "000755"
    owner: root
    group: root
    content: |
      #!/bin/bash
      set -xe

      INSTANCE_ID=$(/opt/aws/bin/ec2-metadata -i | awk '{print $2}')
      REGION=$(/opt/aws/bin/ec2-metadata -z | awk '{print substr($2, 0, length($2)-1)}')
      TAG="elasticbeanstalk:environment-name"

      ENVIRONMENT_NAME=$(aws ec2 describe-tags \
        --output text \
        --filters "Name=resource-id,Values=${INSTANCE_ID}" \
                  "Name=key,Values=${TAG}" \
        --region "${REGION}" \
        --query "Tags[*].Value")
      echo "s3://elasticbeanstalk-my-region-my-accountid/cache/assets-${ENVIRONMENT_NAME}.tar.gz"
```
