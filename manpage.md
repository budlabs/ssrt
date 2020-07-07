`ssrt` - simplescreenreocrder - now even simpler

SYNOPSIS
--------
```text
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR] [--input-file|-i FILE] [--mute|-m] [--container|-n CONTAINER] [--codec|-e CODEC]  
ssrt --help|-h
ssrt --version|-v
```

DESCRIPTION
-----------
*event scripts* are stored in
**SSR_CONFIG_DIR**/events , as executable files
with the same name as the event can be placed.
When **ssrt** is launched for the first time a
sample `events` directory will be created but the
scripts are *"empty"*.


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
`echo record-pause > /tmp/ssrt/in` . See
simplescreenrecorder man page or `--help` for list
of available commands.

`--mute`|`-m`  
set the option **audio_enabled** to false, and no
sound will be recorded.

`--container`|`-n` CONTAINER  
set the option **container** to CONTAINER .
example containers are `mkv` and `webm`.

`--codec`|`-e` CODEC  
set the option **video_codec** to CODEC. Defaults
to `h264` (or `vp8` for **webm**).

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



