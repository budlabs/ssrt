#!/bin/bash

# @<file>         Exclude the specified file from being watched.
# --exclude <pattern>
#                 Exclude all events on files matching the
#                 extended regular expression <pattern>.
#                 Only the last --exclude option will be
#                 taken into consideration.
# --excludei <pattern>
#                 Like --exclude but case insensitive.
# --include <pattern>
#                 Exclude all events on files except the ones
#                 matching the extended regular expression
#                 <pattern>.
# --includei <pattern>
#                 Like --include but case insensitive.
# -m|--monitor    Keep listening for events forever or until --timeout expires.
#                 Without this option, inotifywait will exit after one event is received.
# -d|--daemon     Same as --monitor, except run in the background
#                 logging events to a file specified by --outfile.
#                 Implies --syslog.
# -r|--recursive  Watch directories recursively.


while read -r ; do
  clear
  ./build.sh
done < <(
  inotifywait -rme close_write  . \
  --exclude 'createconf|ssrt[.]sh$|[^s][^h]$' 
)
