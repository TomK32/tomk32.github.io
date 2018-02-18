---
layout: post
title: Delayed Job - Quick tip against bad performance
tags:
  - mongodb
  - mongoid
  - DelayedJob
date: 2018-02-18
---
Not sure how I could have forgotten to create all the indexes that [delayed job](https://github.com/collectiveidea/delayed_job) with MongoId, maybe they were
added later to the gem, maybe I just forgot.

Anyways, while running a later batch of 300000 jobs to process images the performance was miserable, a job every five seconds. After a lengthy search I stumbled
accross the very similar [issue #650](https://github.com/collectiveidea/delayed_job/issues/650) and indeed that was my problem.

Here's what you need to create the necessary index as found in the [delayed_job_mongoid](https://github.com/collectiveidea/delayed_job_mongoid/blob/master/lib/delayed/backend/mongoid.rb#L24) gem.

    db.delayed_backend_mongoid_jobs.ensureIndex({locked_by: -1, priority: 1, run_at: 1}, {background: 1})
