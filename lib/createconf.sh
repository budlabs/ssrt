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


# [[ -f $opf ]] || ERX could not find output file "$opf"
# ifcmd "$_previewcommand" || choice=Yes

# while [[ ${choice:=Maybe} = Maybe ]]; do
#   eval "$_previewcommand '$opf'" > /dev/null 2>&1
#   choice=$(menu -p "Save file? " Yes No Maybe New)
#   : "${choice:=No}"
# done

# [[ $choice = Yes ]] && save "$opf"

# rm -f "$opf"
# [[ $choice = New ]] && exec "$0"
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
cat << 'EOCONF' > "$trgdir/ssrt.conf"
# when a ssr command (f.i. record-start) 
# is appended to infile while ssr is running
# it will get executed
infile = /tmp/ssrt/in

# 'command' that will be used to preview recording
# if command is not found, preview is skipped
# and save action is asumed.
previewcommand = mpv

# when saving a recording, if only a tartget
# directory is specified, use this default name.
defaultname = testdef

# if timeformat `date(1)` is specified and if only
# a tartget directory is specified,  append
# timestamp to saved file
timeformat = %y%m%d%-H:%M:%S

# default directory to save recording
# if not set either XDG_USER_VIDEOS or HOME will
# be used. Another location can be specied in menu
# when a file is about to be saved.
savedir =

# comma separated list of menu commands to try
# when a menu is needed
menus = i3menu,dmenu,rofi

# if set this command will get evaluated when a menu
# is needed. 
# %f will be replaced with filter string.
# %p will be replaced with prompt string.
# custommenu = rofi -dmenu -p '%p' -filter '%f'
custommenu =

# syntax:ssHash
EOCONF

}
