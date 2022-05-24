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

