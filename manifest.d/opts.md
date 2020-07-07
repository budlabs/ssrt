# options-help-description
Show help and exit.

# options-version-description
Show version and exit.

# options-pause-description
Toggle play/pause of an ongoing recording or start a new recording if there is none.

# options-delay-description
Adds a delay in SECONDS (sleep) before starting a new recording. Has no effect when stopping a recording or toggling play/pause. This will also trigger the **delay event** and pass SECONDS as the first argument. 

# options-select-description
Execute `slop(1)` before starting a recording for selection of area to record. Without this option the full active monitor will be recorded.

# options-config-dir-description
Override the environment variable **SSR_CONFIG_DIR**. Defaults to `~/.ssr` . This will be the directory where the statsfile, configfile and **events directory** will be stored and created.

# options-input-file-description
Override the environment variable **SSRT_INPUT_FILE**. Defaults to `/tmp/ssrt/in` . Commands can be appended to this file while the recording is running.  
`echo record-pause > /tmp/ssrt/in` . See simplescreenrecorder man page or `--help` for list of available commands.

# options-mute-description
set the option **audio_enabled** to false, and no sound will be recorded.

# options-container-description
set the option **container** to CONTAINER . example containers are `mkv` and `webm`.

# options-codec-description
set the option **video_codec** to CODEC. Defaults to `h264` (or `vp8` for **webm**).
