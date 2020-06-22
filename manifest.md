---
description: >
  simplescreenreocrder - now even simpler
updated:       2020-06-22
version:       2020.06.22.25
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

*event scripts* are stored in **SSR_CONFIG_DIR**/events , as executable files with the same name as the event can be placed. When **ssrt** is launched for the first time a sample `events` directory will be created but the scripts are *"empty"*.
