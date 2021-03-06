#!/bin/bash

CONF="/usr/bin/ph/fingerprint/etc/fingerprint.conf"
source $CONF

PATH=$PATH:/usr/bin/ph/emplalt/bin

date=`date +%Y-%m-%d`

ACTIVE_USERS_FMS="/usr/bin/ph/fingerprint/data/users_fms.txt"
USERS_FP="/usr/bin/ph/fingerprint/data/users_fp.txt"

JMAIL="/usr/bin/ph/jmail.s"
WGET="/usr/bin/wget"
URL="http://poleo.yum.com.mx/sisdevel/fingerprint"
HOST=`hostname`
STORE_ID=${HOST:2:3}
SENDER="mx"${HOST:1:4}"r"
MAILS_FILE="${STORE_ID}.txt"

if [ -s /tmp/fp_mails.txt ]; then
    /bin/rm -f /tmp/fp_mails.txt
fi

$WGET --quiet --output-document=/tmp/fp_mails.txt $URL/$MAILS_FILE

if [ -z /tmp/fp_mails.txt ]; then
    DESTS="sergio.cuellar,anibal.avelar,juanjose.martinez,fernando.apud"
else
    DESTS="`/bin/cat /tmp/fp_mails.txt`"
fi

SUBJ="Usuarios FMS vs Usuarios en lector de huellas CC ${STORE_ID}"

if [ -e ${ACTIVE_USERS_FMS} ]; then
    /bin/rm ${ACTIVE_USERS_FMS}
fi

if [ -e ${USERS_FP} ]; then
    /bin/rm ${USERS_FP}
fi

#/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat | cut -d\| -f2 | sort -n > /usr/bin/ph/fingerprint/data/users_fms.txt

FMS=`ls -t /usr/bin/ph/emplalt/dat/*.ok | head -n1`

cut -d\| -f6  ${FMS} | sort  > ${ACTIVE_USERS_FMS}

/usr/local/bin/curl -sS http://${IP}/csl/login | grep -i password

if [ $? -eq 1 ]; then
    exit 1
fi

/usr/bin/ph/fingerprint/bin/getRegUserFP.sh $date > ${USERS_FP}

if [ ! -s ${USERS_FP} ]; then
    MSG="No se pudo descargar la lista de usuarios del lector"    
    DESTS="sergio.cuellar"
    $JMAIL "${SENDER}" "${DESTS}" "${SUBJ}" "${MSG}"
    exit 1
fi

UNREGISTERED_IN_FP=`comm -23 ${ACTIVE_USERS_FMS} ${USERS_FP}`

if [ ! -z "${UNREGISTERED_IN_FP}" ]; then
    if [ -e /tmp/mailfp.txt ]; then
        /bin/rm /tmp/mailfp.txt
    fi
    OLDIFS=$IFS
    IFS=
    MSG="Los siguientes asociados les falta ser registrados en el lector de huellas."    
    echo ${MSG} > /tmp/mailfp.txt
    echo ${UNREGISTERED_IN_FP} >> /tmp/mailfp.txt
    IFS="$OLDIFS"
    $JMAIL "${SENDER}" "${DESTS}" "${SUBJ}" "`cat /tmp/mailfp.txt`"
    /bin/rm /tmp/mailfp.txt
fi

