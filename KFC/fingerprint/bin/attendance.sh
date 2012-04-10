#!/bin/bash

NOW=`date +"%d-%m-%y"`

date_id=`date +"%Y-%m-%d"`

LOGFILE="/usr/bin/ph/fingerprint/logs/$NOW.log"

exec 1> $LOGFILE 2>&1

id=$1
emp_num=`/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat | grep $id | cut -d\| -f2`
in_out=$2

IN="IN"

timein1=`psql -U postgres -q -t -d dbeyum -c  "SELECT timein1 FROM pp_emp_check WHERE emp_num='$emp_num' AND date_id='$date_id'"`
timeout1=`psql -U postgres -q -t -d dbeyum -c "SELECT timeout1 FROM pp_emp_check WHERE emp_num='$emp_num' AND date_id='$date_id'"`

timein1=`psql -U postgres -q -t -d dbeyum -c  "SELECT timein2 FROM pp_emp_check WHERE emp_num='$emp_num' AND date_id='$date_id'"`
timeout2=`psql -U postgres -q -t -d dbeyum -c "SELECT timeout2 FROM pp_emp_check WHERE emp_num='$emp_num' AND date_id='$date_id'"`

empname=`psql -U postgres -q -t -d dbeyum -c  "SELECT name FROM pp_employees WHERE emp_num='$emp_num'"`

timein1=`echo $timein1   | sed 's/^ //g'`
timeout1=`echo $timeout1 | sed 's/^ //g'`

timein2=`echo $timein2   | sed 's/^ //g'`
timeout2=`echo $timeout2 | sed 's/^ //g'`

empname=`echo $empname   | sed 's/^ //g'`

echo "emp_num=$emp_num in_out=$in_out empname=$empname timein1=$timein1 timeout1=$timeout1 timein2=$timein2 timeout2=$timeout2"

if [ "$in_out" = "$IN" ]; then
    if [ ! -z "$timein1" ] && [ ! -z "$timein2" ]; then
        Xdialog --title "Info" --screen-center --msgbox "$empname ya ingresaste tu entrada" 10 60
    else
        Xdialog --title "Info" --screen-center --msgbox "$empname, favor de realizar tu entrada en el lector de huellas digitales" 10 80
    fi
else
    if [ ! -z "$timeout1" ] && [ ! -z "$timeout2" ]; then
        Xdialog --title "Info" --screen-center --msgbox "$empname ya realizaste tu salida" 10 60
    else
        Xdialog --title "Info" --screen-center --msgbox "$empname, favor de realizar tu salida en el lector de huellas digitales" 10 80
    fi
fi


