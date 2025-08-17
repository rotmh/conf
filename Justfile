set shell := [ "fish", "-c" ]

default-host := "flamingo"

alias s := switch-system

switch-system host=default-host:
    nh os switch -H {{host}} .
