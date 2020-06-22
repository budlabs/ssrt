#!/bin/bash

### createconf() function is automatically generated
### by bashbud based on the content of the conf/ directory

createconf() {
local trgdir="$1"
declare -a aconfdirs

aconfdirs=(
"$trgdir/events"
"$trgdir/events/lib"
)

mkdir -p "$1" "${aconfdirs[@]}"

cat << 'EOCONF' > "$trgdir/events/lib/ifcmd"
#!/usr/bin/env bash

command -v "$1" > /dev/null
EOCONF

chmod +x "$trgdir/events/lib/ifcmd"
cat << 'EOCONF' > "$trgdir/events/delay"
#!/usr/bin/env bash

# this event is triggered before recording starts
# if --delay options is used. If there exist no
# executable file: events/delay
# a silent sleep will be used

# the argument passed to --delay is available as
# $1 in this file.
declare -i del=$1 
declare -i _dunstid=1338

# ifcmd is a script in the events/lib directory
# that direcory will be in all events PATH. 

if ifcmd dunstify ; then
  while ((del--)); do
    dunstify -r "$_dunstid" "recording starts in $((del+1))"
    sleep 1
  done
  
  dunstify --close "$_dunstid"
elif ifcmd notify-send ; then
  notify-send --expire-time "$del" \
    "recording delayed $del seconds."
  sleep "${del}"
else
  sleep "${del}"
fi
EOCONF

chmod +x "$trgdir/events/delay"
cat << 'EOCONF' > "$trgdir/events/stop"
#!/usr/bin/env bash

# this event gets triggered when recording stops.

# the event varialbe $SSR_OUTPUTFILE contains the
# full path to the current recording.

EOCONF

chmod +x "$trgdir/events/stop"
cat << 'EOCONF' > "$trgdir/events/resume"
#!/usr/bin/env bash

# this event gets triggered when ssrt is executed
# when a paused recording is resumed.

# the event varialbe $SSR_OUTPUTFILE contains the
# full path to the current recording.

EOCONF

chmod +x "$trgdir/events/resume"
cat << 'EOCONF' > "$trgdir/events/start"
#!/usr/bin/env bash

# this event gets triggered when ssrt a new recording
# starts.
# the event is actually triggered just before the recording
# starts, hence the event varialbe $SSR_OUTPUTFILE 
# is empty here.
EOCONF

chmod +x "$trgdir/events/start"
cat << 'EOCONF' > "$trgdir/events/pause"
#!/usr/bin/env bash

# this event gets triggered when ssrt is executed
# with the --pause option when there is an ongoing
# recording i.e. when a recording is paused.

# the event varialbe $SSR_OUTPUTFILE contains the
# full path to the current recording.
EOCONF

chmod +x "$trgdir/events/pause"
}
