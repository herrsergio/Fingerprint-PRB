#!/bin/bash

CONF="/usr/bin/ph/fingerprint/etc/fingerprint.conf"

if [ -e $CONF ]; then
    source $CONF
    ping -q -c 1 $IP >/dev/null 2>&1
fi
    
