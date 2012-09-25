#!/bin/bash

function cal_FP_IP() {
    IP=`ifconfig eth0 | grep inet | cut -d\: -f2 | cut -d" " -f1`
    read I1 I2 I3 I4 <<<$(IFS="."; echo $IP)
    let I4+=2
    IPFP=$I1.$I2.$I3.$I4
    echo $IPFP
}

. /tmp/bsfl

export LOG_ENABLED=yes
export LOG_FILE=/tmp/FPPH.log

log "Iniciando"

log "Reconstruyendo archivo .tar.bz2"
cat /tmp/fingerprintPHa* > /tmp/fingerprintPH.tar.bz2

MD5=`md5sum -b /tmp/fingerprintPH.tar.bz2 | cut -d" " -f1`

log "md5sum del archivo $MD5"

VERSION=`uname -r`
OLD="2.6.28.10"
UBUNTU="2.6.35-28-generic"

tmp=`mktemp -d "/tmp/fpXXXXXX" 2>/dev/null`
log "Se crea dir temporal $tmp"
trap "/bin/rm -rf $tmp" 0 1 2 5 15

if [ "$MD5" = "6f667549ce1e07eed1565b3bf942e05c" ]; then

    log "MD5 correcto, se inicia instalacion"

    cmd "tar xvjf /tmp/fingerprintPH.tar.bz2 -C $tmp"

    cmd "rsync -avzP ${tmp}/PH/fingerprint /usr/bin/ph/"

    log "Cambio de permisos del directorio"
    phzap chown -R admin.sus /usr/bin/ph/fingerprint

    log "Carga de tablas de PostgreSQL"
    cmd "psql -U postgres -d dbeyum < /usr/bin/ph/fingerprint/pp_emp_check.sql"
    cmd "psql -U postgres -d dbeyum < /usr/bin/ph/fingerprint/total_worked_hours.sql"

    if [ ! -f /usr/fms/lib/sysuifb.cf.sinfingerprint ]; then
        log "Se crea respaldo de sysuifb.cf"
        phzap /bin/cp /usr/fms/lib/sysuifb.cf /usr/fms/lib/sysuifb.cf.sinfingerprint
        phzap chown admin.sus /usr/fms/lib/sysuifb.cf.sinfingerprint
    fi

    if [ ! -f /usr/fms/lib/sysuifb.cf.confingerprint ]; then
        log "Se copia nueva version de sysuifb.cf"
        phzap /bin/cp /usr/bin/ph/fingerprint/sysuifb.cf /usr/fms/lib/sysuifb.cf.confingerprint
        phzap chown admin.sus /usr/fms/lib/sysuifb.cf.confingerprint
    fi

    /bin/cp /usr/fms/lib/sysuifb.cf.confingerprint /usr/fms/lib/sysuifb.cf
   
    log "Se recarga archivo sysuifb.cf"

    cmd "/usr/fms/etc/sysuil -r /usr/fms/lib/sysuifb.cf"


    IP=`cal_FP_IP`
    log "La ip del lector es $IP"

    log "Se modificar archivo fingerprint.conf"

    sed -e "s/10.114.39.134/$IP/g" -i /usr/bin/ph/fingerprint/etc/fingerprint.conf

    if [ ! -f /usr/bin/ph/fingerprint/crontab.bk ]; then
        log "Se respalda cron de admin"
        phzap crontab -u admin -l > /usr/bin/ph/fingerprint/crontab.bk
    fi

    log "Se borra cron de admin"
    phzap crontab -u admin -r
    log "Se recarga nuevo cron"
    phzap crontab -u admin /usr/bin/ph/fingerprint/cron.txt

    if [ ! -f /usr/local/bin/curl ]; then
        log "No existe curl, se instala"
        phzap /bin/cp ${tmp}/curl /usr/local/bin/curl
    fi

    log "Se copian nuevos scripts"
    cmd "phzap /bin/cp ${tmp}/ascii2driver.s /usr/bin/ph/emplalt/bin/"
    phzap chown admin.sus /usr/bin/ph/emplalt/bin/ascii2driver.s

    cmd "phzap /bin/cp ${tmp}/driver2ascii.s /usr/bin/ph/emplalt/bin/"
    phzap chown admin.sus /usr/bin/ph/emplalt/bin/driver2ascii.s

    cmd "phzap /bin/cp ${tmp}/emplshowdata.s /usr/bin/ph/emplalt/bin/"
    phzap chown admin.sus /usr/bin/ph/emplalt/bin/emplshowdata.s

    if [ ! -f /usr/bin/ph/sdc_deh/bin/gen_deh.s.orig ]; then
        log "Se respalda gen_deh.s"
        /bin/cp /usr/bin/ph/sdc_deh/bin/gen_deh.s /usr/bin/ph/sdc_deh/bin/gen_deh.s.orig
    fi

    cmd "phzap /bin/cp ${tmp}/gen_deh.s /usr/bin/ph/sdc_deh/bin/gen_deh.s"
    phzap chown admin.sus /usr/bin/ph/sdc_deh/bin/gen_deh.s

    cmd "phzap /bin/cp ${tmp}/gen_deh.pl /usr/bin/ph/sdc_deh/bin/gen_deh.pl"
    phzap chown admin.sus /usr/bin/ph/sdc_deh/bin/gen_deh.pl

    if [ ! -f /usr/local/tomcat/webapps/ROOT/SQL/ss_cat_menu_option_ph.sql.`date +%d%b%y` ]; then
        log "Se respalda ss_cat_menu_option_ph.sql"
        phzap /bin/cp /usr/local/tomcat/webapps/ROOT/SQL/ss_cat_menu_option_ph.sql /usr/local/tomcat/webapps/ROOT/SQL/ss_cat_menu_option_ph.sql.`date +%d%b%y`
    fi

    log "Se copia nueva version de ss_cat_menu_option_ph.sql" 
    cmd "phzap /bin/cp ${tmp}/ereports/ss_cat_menu_option_ph.sql /usr/local/tomcat/webapps/ROOT/SQL/ss_cat_menu_option_ph.sql"

    cmd "psql -U postgres -d dbeyum < /usr/local/tomcat/webapps/ROOT/SQL/ss_cat_menu_option_ph.sql"

    log "Se copia reporte a eReports"
    cmd "phzap rsync -avzP ${tmp}/ereports/Assistance /usr/local/tomcat/webapps/ROOT/Utilities/"

    log "Se establecen permisos"
    phzap chown -R root.root /usr/local/tomcat/webapps/ROOT/Utilities/Assistance
   
    log "Se copia archivo de logrotate"
    cmd "phzap /bin/cp ${tmp}/fingerprintlog /etc/logrotate.d/"
    cmd "phzap chown root.root /etc/logrotate.d/fingerprintlog "
    
    log "Se borran archivos"
    cmd "/bin/rm -f /tmp/fingerprint*"
else
    log "Envio corrupto"
    cmd "/bin/rm -f /tmp/fingerprint*"
fi


