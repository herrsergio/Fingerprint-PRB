#!/bin/bash

#set -x

EXPECTED_ARGS=1

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Uso: $0 YYYY-MM-DD"
	exit 1
fi

FECHA=$1

if [ -e /usr/bin/ph/fingerprint/etc/fingerprint.conf ]; then
    source /usr/bin/ph/fingerprint/etc/fingerprint.conf
fi

CURL="/usr/local/bin/curl"
ROOTURL="http://${IP}"
OUTPUT_FILE="/tmp/output_fp.html"
OPTIONS=""
LOGIN_OPTS="username=${USER}&userpwd=${PASSWORD}"

COOKIE_FILE="/tmp/cookie_fp.txt"

function get_cookie() {
    if [ -f ${COOKIE_FILE} ]; then
        rm -f ${COOKIE_FILE}
    fi

    ${CURL} -s  --cookie-jar ${COOKIE_FILE}  -G ${ROOTURL} -o ${OUTPUT_FILE}

    ${CURL} -s  --cookie ${COOKIE_FILE} -d ${LOGIN_OPTS} -G ${ROOTURL}/csl/check \
            -o ${OUTPUT_FILE}
} 

function get_ids_page() {
    ${CURL} -s --cookie ${COOKIE_FILE} -G  ${ROOTURL}/csl/report \
			-o ${OUTPUT_FILE}
}	


SOD=`/usr/fms/op/bin/phconfg -n9 -g`

get_cookie
get_ids_page
#get_data

if [ -e /tmp/ids_FP.txt ]; then
    /bin/rm /tmp/ids_FP.txt
fi

perl /usr/bin/ph/fingerprint/bin/getIDs.pl ${OUTPUT_FILE} ${FECHA} 1 | sort 

