set shell := [ "fish", "-c" ]

default-host := "flamingo"

alias s := switch-system
alias su := switch-system-update

switch-system host=default-host:
    nh os switch -H {{host}} . -- --accept-flake-config

switch-system-update host=default-host:
    nh os switch --update -H {{host}} . -- --accept-flake-config
