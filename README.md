# ssrt - simplescreenreocrder - now even simpler
Use [simplescreenrecorder] without using the GUI.

In my global keybinding configuration (**i3wm**) i have the following:  
```
bindsym Mod4+Print exec --no-startup-id ssrt
bindsym Control+Print exec --no-startup-id ssrt --pause
```

So by just pressing
<kbd>Super</kbd>+<kbd>Print-Screen</kbd>
i can start and stop a screenrecording.
The second keybinding uses
<kbd>Ctrl</kbd>
as the modifier and toggle play/pause.

> `--pause` would also start a recording if there is none.
> And the first keybinding will resume a paused recording*.


**ssrt** also trigger *event scripts* on certain
events (start/stop/pause/resume/delay). Any
executable file can be used as an eventscript,
in which the full path to the current recording
will be available in the environment
variable: **SSR\_OUTPUTFILE**.

Some example usecases for the event scripts:  

- unmute the microphone before recording starts
- preview the recording in a videoplayer when recording stops
- convert recorded media
- display notifications on pause and delay


[simplescreenrecorder]: https://www.maartenbaert.be/simplescreenrecorder/

## installation

If you use **Arch Linux** you can get **ssrt**
from [AUR].  

**ssrt** is a **bash** script and beside `bash (1)`
and `simplescreenrecorder(1)`, the only other external 
commands needed are `gawk (1)`, `slop(1)`, and `xrandr(1)`.

(*configure the installation in `config.mak`, if needed*)

```
$ git clone https://github.com/budlabs/ssrt.git
$ cd ssrt
$ make
# make install
$ ssrt -v
ssrt - version: 2020.06.22.1
updated: 2020-06-22 by budRich
```  

[AUR]: https://aur.archlinux.org/packages/ssrt

## usage
    ssrt [OPTIONS]
    -h, --help     | print help and exit  
    -v, --version  | print version info and exit  

*event scripts* are stored in 
**SSR\_CONFIG\_DIR**/events\* ,
as executable files with the same name as the
event (delay|pause|resume|start|stop).
When **ssrt** is launched for the first time a sample
`events` directory will be created but
the scripts are *"empty"*.

> \* SSR\_CONFIG\_DIR defaults to simplescreenrecorders
> configuration directory: `~/.ssr`

