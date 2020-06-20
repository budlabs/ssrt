#!/usr/bin/env bash

createconf() {
local trgdir="$1"
declare -a aconfdirs

aconfdirs=(
"$trgdir/events"
)

mkdir -p "$1" "${aconfdirs[@]}"

cat << 'EOCONF' > "$trgdir/events/stop"
#!/bin/bash

opf=$SSR_OUTPUTFILE
notify-send "i stopped $opf"

EOCONF

chmod +x "$trgdir/events/stop"
cat << 'EOCONF' > "$trgdir/events/resume"
#!/bin/bash

echo i resumed
EOCONF

chmod +x "$trgdir/events/resume"
cat << 'EOCONF' > "$trgdir/events/start"
#!/bin/bash

notify-send "im starting"
EOCONF

chmod +x "$trgdir/events/start"
cat << 'EOCONF' > "$trgdir/events/pause"
#!/bin/bash

echo i paused
EOCONF

chmod +x "$trgdir/events/pause"
}
