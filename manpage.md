`ssrt` - simplescreenreocrder - now even simpler

SYNOPSIS
--------
```text
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR] [--input-file|-i FILE]
ssrt --help|-h
ssrt --version|-v
```

DESCRIPTION
-----------
In my global keybinding configuration (**i3wm**)
i have the following:  
```
bindsym Mod4+Print exec --no-startup-id ssrt
bindsym Mod1+Print exec --no-startup-id ssrt --pause
```


So by just pressing
<kbd>Super</kbd>+<kbd>PrScrn</kbd> i can start and
stop a screenrecording. The second keybinding uses
<kbd>Alt</kbd> as the modifier and toggle
play/pause (*it will also start a recording if
there is none. And the first keybinding will
resume a paused recording*). **ssrt** also
executes commands on different events, namely:  
- delay

- start

- stop

- pause

- resume


With this functionality one could do all kinds of
actions depending on the events, some examples:  
- unmute the microphone before recording starts

- preview the recording in a videoplayer when recording stops

- convert recorded media

- display notifications on pause and delay


I added it as an external "plugin" like system
like this because the needs, options and
applications different users might want to use are
probably more then the number of users.

It looks for events in **SSR_CONFIG_DIR**/events , where executable files with the same name as the event can be placed. When **ssrt** is launched for the first time a sample `events` directory will be created but the are "empty". See [./event-examples] to see a complete setup. 


OPTIONS
-------

`--pause`|`-p`  
Toggle play/pause of an ongoing recording or
start a new recording if there is none.

`--delay`|`-d` SECONDS  
Adds a delay in SECONDS (sleep) before starting a
new recording. Has no effect when stopping a
recording or toggling play/pause. This will also
trigger the **delay event** and pass SECONDS as
the first argument.

`--select`|`-s`  
Execute `slop(1)` before starting a recording for
selection of area to record. Without this option
the full active monitor will be recorded.

`--config-dir`|`-c` DIR  
Override the environment variable
**SSR_CONFIG_DIR**. Defaults to `~/.ssr` . This
will be the directory where the statsfile,
configfile and **events directory** will be stored
and created.

`--input-file`|`-i` FILE  
Override the environment variable
**SSRT_INPUT_FILE**. Defaults to `/tmp/ssrt/in` .
Commands can be appended to this file while the
recording is running.  
`echo record-pause > /tmp/ssrt/in` . See simplescreenrecorder man page or `--help` for list of available commands.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.


ENVIRONMENT
-----------

`SSR_CONFIG_DIR`  

defaults to: $HOME/.ssr

`SSRT_INPUT_FILE`  

defaults to: /tmp/ssrt/in

DEPENDENCIES
------------
`simplescreenrecorder`
`bash`
`gawk`
`xrandr`
`slop`



