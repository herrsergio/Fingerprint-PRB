#!/bin/bash

EMPLOYEE_NUM=$1

if [ -z $EMPLOYEE_NUM ]; then
    echo "Uso: $0 NUM_EMPLEADO"
    exit 1
fi

if [ -f /tmp/tkeclk.txt ]; then
    /bin/rm /tmp/tkeclk.txt
fi

/usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/tkeclk.dat > /tmp/tkeclk.txt

grep -q $EMPLOYEE_NUM /tmp/tkeclk.txt

echo $? # 1, no ha hecho clock-in, 0 ya realizo clock-in

/bin/rm /tmp/tkeclk.txt
