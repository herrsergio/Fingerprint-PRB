#!/bin/bash

LOG_FILE=/usr/bin/ph/fingerprint/logs/clock_employee.log

[ ! -f $LOG_FILE ] && echo "--- inicializa log file ---" > $LOG_FILE
chmod 644 $LOG_FILE
tail -400 $LOG_FILE > $LOG_FILE.bak
mv $LOG_FILE.bak $LOG_FILE

tolog()
{
    MSG=`date +"%y %m %d %T"; echo $1`
    echo $MSG >> $LOG_FILE
}

EMPLOYEE_NUM=$1
EMPLOYEE_RFC=$2
EMPLOYEE_DEPT=$3
EMPLOYEE_PUESTO=$4

CLOCK_OP=$5

EPOCH=$6

EXPECTED_ARGS=6


usage(){
    echo "Uso: $0 NUM_EMPL RFC_EMP DEPT PUESTO [TI|TO] EPOCH"
    exit 1
}


if [ $# -ne $EXPECTED_ARGS ]; then
    usage
fi

if [ -f /tmp/hrcempl.txt ]; then
    /bin/rm /tmp/hrcempl.txt
fi

if [ -f /tmp/tkeclk.txt ]; then
    /bin/rm /tmp/tkeclk.txt
fi

if [ -f /tmp/tkeclk.dat ]; then
    /bin/rm /tmp/tkeclk.dat
fi

/usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/hrcempl.dat > /tmp/hrcempl.txt
/usr/bin/ph/emplalt/bin/empl2ascii.s /usr/fms/data/tkeclk.dat  > /tmp/tkeclk.txt

if [ $CLOCK_OP = "TI" ]; then
    tolog "Operacion de entrada TI"
    tolog "TI para $EMPLOYEE_NUM"
    cat /tmp/hrcempl.txt | awk -F\| -v emp=$EMPLOYEE_NUM '{ if ($22 == emp) print $0 }' >> /tmp/tkeclk.txt
else
    tolog "Operacion de salido TO"
    tolog "TO para $EMPLOYEE_NUM"
    LINE=`cat /tmp/hrcempl.txt | awk -F\| -v emp=$EMPLOYEE_NUM '{ if ($22 == emp) print $0 }'`
    RFC=`echo ${LINE} | cut -d\| -f1`
    #sed -ie "/$LINE/d" /tmp/tkeclk.txt
    grep -v $RFC /tmp/tkeclk.txt > /tmp/tkeclk.tmp
    /bin/mv /tmp/tkeclk.tmp /tmp/tkeclk.txt
fi


/usr/bin/ph/emplalt/bin/ascii2empl.s /tmp/tkeclk.txt > /tmp/tkeclk.dat

# Con esto ya se puede ingresar a cobrar
/bin/mv /tmp/tkeclk.dat /usr/fms/data/tkeclk.dat

# Ahora se necesita agregar la entrada con hora tipo epoch en el tkpaytrn.dat

if [ -f /tmp/tkpaytrn.txt ]; then
    /bin/rm /tmp/tkpaytrn.txt
fi

if [ -f /tmp/tkpaytrn.dat ]; then
    /bin/rm /tmp/tkpaytrn.dat
fi

/usr/bin/ph/fingerprint/bin/tkpay2ascii.s /usr/fms/data/tkpaytrn.dat > /tmp/tkpaytrn.txt

# Entrada
# 1305022305|0||GOJD920715MDF|S|TI|00|92|0|87| |0| |||0|?? | |\000|0|0|0|
# Salida
# 1305062298|0||GOJD920715MDF|S|TO|00|92|0|87| |0| |||0|?? | |\000|0|0|0|

# Epoch time|0||RFC|S|TI o TO|00|Depto|0|Puesto| |0| ||||0|?? | |\000|0|0|0|
#                                      ^                                  ^
#                                a veces es 1 ?                        a veces es 1 ?

tolog "$EPOCH|0||$EMPLOYEE_RFC|S|$CLOCK_OP|00|$EMPLOYEE_DEPT|0|$EMPLOYEE_PUESTO| |0| |||0|?? | |\000|0|0|0|"

echo "$EPOCH|0||$EMPLOYEE_RFC|S|$CLOCK_OP|00|$EMPLOYEE_DEPT|0|$EMPLOYEE_PUESTO| |0| |||0|?? | |\000|0|0|0|" \
     >> /tmp/tkpaytrn.txt

# Originalmente el archivo esta agrupado por empleado y ordenado por hora, al hacer esta concatenacion
# se pierde la agrupacion. Espero no afecte

# Se pasa el ascii a binario
/usr/bin/ph/fingerprint/bin/ascii2tkpay.s /tmp/tkpaytrn.txt > /tmp/tkpaytrn.dat

/bin/mv /tmp/tkpaytrn.dat /usr/fms/data/tkpaytrn.dat


