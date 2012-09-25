## 
##	Module : gen_deh.s	        Date: 98/01/05   Time: 12:40:50
##			Daily transactions Script Module
##
##	Release : 1.4
##	Version : 0.0
##	Delta Time-Date : 98/01/05 12:40:50
##	@(#) gen_deh.s - 98/01/05 rel 1.4 ver 0.0
##
## gen_deh.s - This program generates a "deh" file just like ARMS POS does
##

USAGE="USO: $0 [AA-MM-DD]"
WRKDIR=${WRKDIR:=/usr/bin/ph/sdc_deh}

cd $WRKDIR
. ./.env

cd $BINDIR

# Generate employee list
get_emplist.s > $EMP_FILE

DATE=$1
# Si se corre en el cron de la madrugada
EOD=$2
case $# in 
	0) DATE=`dant.s` ;;

	1) case  "$DATE" in
		[0-9][0-9]-[0-1][0-9]-[0-3][0-9])
			true ;;
		*)
			echo $USAGE
			exit 1 ;;
		esac ;;

	*) echo $USAGE
		exit 1
esac

ALT_DATE=`echo "$DATE" | sed 's/\(..\)-\(..\)-\(..\)/\2-\3-\1/'`
DATE_NEXT=`dsig.s $DATE`

# Actualizando transacciones
tkmertrn -i

# Eliminando registros borrados
tkdeltrn  -d >/dev/null

# MEXICO - LINUX Get unit number with unit.s script
#STORE=`uname -s | sed 's/S//
STORE=`/usr/bin/ph/unit.s`
export STORE

#$BINDIR/tkpay $FMS_DATA/tkpaytrn.dat | 
$BINDIR/tkpay $FMS_DATA/tkpaytrn.dat | egrep "$DATE|$DATE_NEXT" | \
	#awk -vstore=$STORE -vemp_map=$EMP_MAP -vldesc_map=$LDESC_MAP \
	#-f gen_deh.awk | grep $ALT_DATE
    perl $BINDIR/gen_deh.pl | grep $ALT_DATE

if [ -e /tmp/gen_pp.tmp ]; then
    /bin/cp /usr/fms/data/tkpaytrn.dat  /usr/fms/data/tkpaytrn.dat.$DATE
    /bin/cp /usr/fms/data/tkeclk.dat  /usr/fms/data/tkeclk.dat.$DATE
    #> /usr/fms/data/tkpaytrn.dat
    > /usr/fms/data/tkeclk.dat
    phzap /bin/rm /tmp/gen_pp.tmp
fi

# Generates Bonus transactions
bonus.s $DATE $DATE

