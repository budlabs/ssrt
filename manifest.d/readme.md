# readme_banner

This script makes it easy to manage screenrecordings with [simplescreenrecorder] without using the GUI.
See the live action raw uncut demonstration video on **youtube**:
<https://----->

[simplescreenrecorder]: https://www.maartenbaert.be/simplescreenrecorder/
# readme_install

If you use **Arch Linux** you can get **ssrt** from [AUR](https://aur.archlinux.org/packages/ssrt/).  

**ssrt** have no dependencies and all you need is the `ssrt` script in your PATH. Use the Makefile to do a systemwide installation of both the script and the manpage.  

(*configure the installation destination in the Makefile, if needed*)

```
$ git clone https://github.com/budlabs/ssrt.git
$ cd ssrt
# make install
$ ssrt -v
ssrt - version: 2020.06.22.1
updated: 2020-06-22 by budRich
```
