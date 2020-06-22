The purpose of this example configuration is to showcase how it could be set up, not to be a 100% production ready setup. (I don't use it myself).  

The scripts executes a number of external commands, so for this configuration to work make sure the following commands are available in your path:  

- mpv , used to preview videos
- dmenu, rofi or i3menu, used for menus
- polify and polybar, used to display recording timer in polybar

And in polybar a module looking like this needs to be defined:
```
[module/timer]
type = custom/ipc
hook-0 = polify --module timer
initial = 1
```
