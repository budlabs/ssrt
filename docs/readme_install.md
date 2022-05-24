## installation

If you use **Arch Linux** you can get **ssrt**
from [AUR].  

**ssrt** is a **bash** script and beside `bash (1)`
and `simplescreenrecorder(1)`, the only other external 
commands needed are `gawk (1)`, `slop(1)`, and `xrandr(1)`.

(*configure the installation in `config.mak`, if needed*)

```
$ git clone https://github.com/budlabs/ssrt.git
$ cd ssrt
$ make
# make install
$ ssrt -v
ssrt - version: 2020.06.22.1
updated: 2020-06-22 by budRich
```  

[AUR]: https://aur.archlinux.org/packages/ssrt

