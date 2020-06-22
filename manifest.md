---
description: >
  simplescreenreocrder - now even simpler
updated:       2020-06-22
version:       2020.06.22.14
author:        budRich
repo:          https://github.com/budlabs/ssrt
created:       2020-06-19
type:          default
license:       bsd-2-clause
dependencies:  [simplescreenrecorder, bash, gawk, xrandr, slop]
see-also:      [bash(1), awk(1), simplescreenrecorder(1), xrandr(1), slop(1)]
environ:
    SSR_CONFIG_DIR:  $HOME/.ssr
    SSRT_INPUT_FILE: /tmp/ssrt/in
synopsis: |
    [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR] [--input-file|-i FILE]
    --help|-h
    --version|-v
...

# long_description

In my global keybinding configuration (**i3wm**) i have the following:  
```
bindsym Mod4+Print exec --no-startup-id ssrt
bindsym Mod1+Print exec --no-startup-id ssrt --pause
```

So by just pressing <kbd>Super</kbd>+<kbd>PrScrn</kbd> i can start and stop a screenrecording. The second keybinding uses <kbd>Alt</kbd> as the modifier and toggle play/pause (*it will also start a recording if there is none. And the first keybinding will resume a paused recording*). **ssrt** also executes commands on different events, namely:  
- delay
- start
- stop
- pause
- resume

With this functionality one could do all kinds of actions depending on the events, some examples:  
- unmute the microphone before recording starts
- preview the recording in a videoplayer when recording stops
- convert recorded media
- display notifications on pause and delay

I added it as an external "plugin" like system like this because the needs, options and applications different users might want to use are probably more then the number of users.

It looks for events in **SSR_CONFIG_DIR**/events , where executable files with the same name as the event can be placed. When **ssrt** is launched for the first time a sample `events` directory will be created but the are "empty". See [./event-examples] to see a complete setup. 
