# readme_banner

This script makes it easy to manage screenrecordings with [simplescreenrecorder] without using the GUI.

In my global keybinding configuration (**i3wm**) i have the following:  
```
bindsym Mod4+Print exec --no-startup-id ssrt
bindsym Control+Print exec --no-startup-id ssrt --pause
```

So by just pressing <kbd>Super</kbd>+<kbd>Print-Screen</kbd> i can start and stop a screenrecording. The second keybinding uses <kbd>Ctrl</kbd> as the modifier and toggle play/pause (*it will also start a recording if there is none. And the first keybinding will resume a paused recording*).  

**ssrt** also trigger *event scripts* on certain events (start/stop/pause/resume/delay). Any executable file can be used as an eventscript, in which the full path to the current recording will be available in the environment variable: **SSR_OUTPUTFILE**.

With this functionality one could do all kinds of stuff, some examples:  

- unmute the microphone before recording starts
- preview the recording in a videoplayer when recording stops
- convert recorded media
- display notifications on pause and delay

See the live action raw uncut demonstration video on **youtube**:
<https://----->

[simplescreenrecorder]: https://www.maartenbaert.be/simplescreenrecorder/

# readme_install

If you use **Arch Linux** you can get **ssrt** from [AUR](https://aur.archlinux.org/packages/ssrt/).  

**ssrt** have no dependencies and all you need is the `ssrt` script in your PATH. Use the Makefile to do a systemwide installation of both the script and the manpage.  

(*configure the installation destination in the Makefile, if needed*)

```
$ git clone https://github.com/budlabs/ssrt.git
$ cd ssrt
# make install
$ ssrt -v
ssrt - version: 2020.06.22.1
updated: 2020-06-22 by budRich
```
