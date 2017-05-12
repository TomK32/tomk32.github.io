---
layout: post
title: "Use view helpers in your mailers"
date: "2017-05-12 13:59:22 +0200"
tags: rails ActionMailer
---
To be honest, I thought those would be loaded automatically, knowing how much Rails does automagically.
But no, this is what you have to do:

    class ApplicationMailer < ActionMailer::Base
      add_template_helper(MarkdownHelper)
    end
