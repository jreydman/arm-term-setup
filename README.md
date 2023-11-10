# Automate dumper working infrastructure for arm systems

codename: ascendI

specification: XDG

Logic:

ascendI.exe > bash[init] {
    bash:[compose]>SETUP
    1. checkin rcfile environments > xdg:config:[shell]:rcfile
       1. ln xdg:config:[shell]:rcfile > ~/rcfile
    2. checkin [aum]
       1. [aum]:refresh/update
       2. [aum]:upload ext > ~/.rcfile
    3. bash[compose]:reboot
} > 

---

## Relation links

* [Homepage](README.md)

* [Version control managers](docs/version-control-managers-manual.md)

* [Sync pass util integration](docs/sync-pass-util-integration.md)

* [Shell infrastructure](docs/shell-infrastructure-munual.md)

* [Shell configuration](docs/shell-configuration-manual.md)

* [List apps for working](docs/list-apps-working.md)
