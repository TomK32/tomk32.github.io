---
title: What to do when your Linux upgrade goes wrong
tags:
  - linux
  - backup
---
Strange how rarely I write about Linux, the OS that I'm using since 1998 (with some gap filled with OSX).
I love it to bits because it's is super reliable. But of course there are exceptions like 20 years ago
when I was using Debian testing and libpam had a bad update. Took me a week to get back into my system.
The old days of not having a backup-system...

This week's outtake was much shorter and completely my fault, but my backup-strategy was a second PC. Not the perfect
solution for such situations.

**First of all, what did I do wrong?** Well, I downgraded readline. Bash didn't like that, some I realized only after
reboot the system after returning home from work.

**So, what took you so long?** Well, not being able to get into my system to reinstall the newer readline version that
was still in pacman's cache. My disks aren't ecrypted (files are, there's even a mountable encrypted disk image) so
recovery was easy enough.

**What will I change in the near future?** First off all, a newer, bigger disk is on my shopping-list. I'l configure it to feature
an additional, minimalistic boot drive that I can use to access my other partitions when needed.
Another fallback will be changing the external hard-drives that I have around the house, I'll add boot drives to those as well.
You might wonder why that, but the reason is quite simple: I don't want to rely on an USB stick for a boot drive because I probably
will overwrite it after a while.
