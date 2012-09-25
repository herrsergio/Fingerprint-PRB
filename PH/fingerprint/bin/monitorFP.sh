#!/bin/bash

CONF="/usr/bin/ph/fingerprint/etc/fingerprint.conf"

source $CONF

COUNT=5

JMAIL="/usr/bin/ph/jmail.s"
HOSTNAME=`hostname`
CC=${HOSTNAME:1:4}
DESTS="sergio.cuellar,anibal.avelar,fernando.apud,juanjose.martinez"
SENDER="mx${CC}r"


count=$(ping -c $COUNT $IP | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
if [ $count -eq 0 ]; then
    MSG="Conectividad con dispositivo fingerprint nula `date`"
    SUBJ="Conectividad con fingerprint en centro ${CC} nula"
    ${JMAIL} "${SENDER}" "${DESTS}" "${SUBJ}" "${MSG}"
    exit 1
fi

/usr/local/bin/curl -sS http://${IP}/csl/login | grep -i password

if [ $? -eq 1 ]; then
    MSG="Conectividad con servidor web de dispositivo fingerprint nula `date`"
    SUBJ="Conectividad nula con servidor web fingerprint en ${CC}"
    ${JMAIL} "${SENDER}" "${DESTS}" "${SUBJ}" "${MSG}"
fi

