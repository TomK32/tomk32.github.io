---
title: Bash scrip to switch Pulseaudio sinks
tags:
    - linux
    - bash
    - pulseaudio
---

Who doesn't love using the keyboard even for simple things like switching the output (or sink as pulseaudio calls it) for you audio? My setup is a set of external speakers, a monitor with rather bad speakers and plugged into the monitor at all time my headphones. That makes three sinks which makes my script a bit more complicated than a simple toggle to the other (i.e. IDLE sink) would be.

The obvious other use-case for this script is one systems where you don't have a display.

```bash
#!/bin/env sh

# get the names and give each a number (-n)
sinks=`pactl list sinks | grep Name | grep -n Name`

# echo with " to get the newlins properly and find which we currently use
current_sink_number=`echo "$sinks" | grep \$(pactl get-default-sink) | cut -d: -f 1`

# modulo on current sink + 1 to get 0 if we are already on the last one
new_sink_number=$(((($current_sink_number + 1) % `echo "$sinks" | wc -l`) + 1))
new_sink=`echo "$sinks" | head -n $new_sink_number | tail -n 1 | cut -d: -f 3`
pactl set-default-sink $new_sink
pactl get-default-sink

# use grep with perl expressions and only-matching (-o) to get the new nice looking name
new_sink_name=`echo $(pactl list sinks)| grep -P -o "$(pactl get-default-sink).*?device.product.name.= \"([^\"]*)"|grep -P -o "[^\"]*\Z"`
notify-send "Using sink $new_sink_name"
```

If your Linux skills are still basic, here's how to install and use the script:
Put the code into `bin/switch-pulseaudio-sink.sh` then `chmod 700 bin/switch-pulseaudio-sink.sh` to make the file executable
and lastly assign it some keyboard shortcut in your desktop manager. In xfce4 I'm using Alt-Shift-S (s for sink) but you might have extra multimedia keys on your keyboard
that you could re-assign with acpi, in that case `/etc/acpid/handler.sh` is most likely on your system available for this.
