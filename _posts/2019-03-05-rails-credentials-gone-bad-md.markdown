---
layout: post
title: Rails credentials gone bad
date: "2019-03-05"
tags:
  - rails
  - bug
  - credentials
---
It'd be boring if you didn't start you day with a nice error message,
no matter what I tried, even editing the credentials gave an error.
Here's the one I got today, and some quick look into `ActiveSupport::MessageEncryptor`
showed me that something was wrong with the credentials.

    rescue in _decrypt': ActiveSupport::MessageEncryptor::InvalidMessage

The credentials.yml.enc had been modified in the repo just slightly
during a merge conflict and though they were now the same again, it didn't play along.
Maybe a newline or something?

Anyways, I went straight for a solution by resetting the repo to before the change to
the `credentials.yml.enc` file, run `rails credentials:edit`
to copy its contents into a temporary file, back to the terminal, reset to `HEAD`
run `rails credentials:edit` again and paste in the contents from the temporary file.

Easy, right?
