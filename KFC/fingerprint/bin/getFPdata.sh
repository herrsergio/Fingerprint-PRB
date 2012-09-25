#!/bin/bash

#set -x

. /usr/bin/ph/sysshell.new FMS
FMS_STORE=`uname -s| cut -c2-`; export FMS_STORE
tkclckin

EXPECTED_ARGS=1

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Uso: $0 YYYY-MM-DD"
	exit 1
fi

FECHA=$1

if [ -e /usr/bin/ph/fingerprint/etc/fingerprint.conf ]; then
    source /usr/bin/ph/fingerprint/etc/fingerprint.conf
fi

#CURL="/usr/bin/curl"
CURL="/usr/local/bin/curl"
#ROOTURL="http://192.168.110.23"
ROOTURL="http://${IP}"
#ROOTURL="http://10.114.13.68"
OUTPUT_FILE="/tmp/output_fp.html"
#OPTIONS="username=2&userpwd=2&userlogin=management+logon+"
OPTIONS=""
#LOGIN_OPTS="username=administrator&userpwd=654321"
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

function get_data() {
    for PARMS in `perl /usr/bin/ph/fingerprint/bin/getIDs.pl ${OUTPUT_FILE} ${FECHA}`; do
        ${CURL} -s --cookie ${COOKIE_FILE} -G -d "${PARMS}" ${ROOTURL}/csl/query \
            -o $OUTPUT_FILE	
        #links $OUTPUT_FILE
        perl /usr/bin/ph/fingerprint/bin/parseHours.pl ${OUTPUT_FILE} ${FECHA}
        sleep 2
    done
}

SOD=`/usr/fms/op/bin/phconfg -n9 -g`

#if [ $SOD -eq 2 ]; then

    get_cookie

    get_ids_page

    get_data
#fi
