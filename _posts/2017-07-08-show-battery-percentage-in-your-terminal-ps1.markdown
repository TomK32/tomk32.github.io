---
layout: post
title: "Show Battery percentage in your terminal PS1"
date: "2017-07-08 19:38:34 +0200"
tags: linux shell PS1 minimalism laptop
---
If you are a minimalist like me your desktop will be clean of any distractions.
No Dock like on OSX, no task bar or status bar, a maximum the program windows have borders.

This minimalism, while satisfying leads to a larger need for information about your system,
in the case of a laptop that's just one information, sorry, two if you want the time as well,
that you need to access regularly: The battery. Even my X240 occassionally needs some
juice.

My favourite command-line programm to get the battery status is `acpi` but if you can
extract the necessary information any other program will do just as fine for my little
helpful setup.

Where I show the battery status is the one place I have constantly running, a terminal window.
And to show it I (ab)use is [`PS1`](https://wiki.archlinux.org/index.php/Bash/Prompt_customization)
and here's how:

```shell
function battery_percentage {
  echo `acpi -b|cut -d',' -f2|cut -d' ' -f2"`
}
PS1="\A \$(battery_percentage) $ "
```

The result looks like this:

    13:37 42% $

Add the code into your `.profile` to make it stick.
