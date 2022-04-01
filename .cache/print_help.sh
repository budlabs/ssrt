#!/bin/bash

__print_help()
{
  cat << 'EOB' >&3  
usage: ssrt [OPTIONS]

    -o, --hello WORD | short description          
    -v, --version    | print version info and exit
    -h, --help       | print help and exit        
EOB
}
