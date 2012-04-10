#!/bin/bash

#set -x
#exec 2>/tmp/is_in_fp.log

PATH=$PATH:/usr/bin/ph/emplalt/bin

date=`date +%Y-%m-%d`

id=$1

emp_num=`/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat | grep $id | cut -d\| -f2`

comm -23 /usr/bin/ph/fingerprint/data/users_fms.txt /usr/bin/ph/fingerprint/data/users_fp.txt | grep -q $emp_num

#0 sí está el usuario de fms en el lector
#1 no  está el usuario de fms en el lector
echo $?
