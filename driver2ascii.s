#!/bin/bash

# driver  binary file to ascii

#    Copyright (C) 2011 Sergio Cuellar

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.



USAGE="Usage: $0 driver_db  [ > driver_db_ascii_file ]"
if [ $# -ne 1 -o "$1" = "-h" ]; then
   echo $USAGE
   exit 1
fi
if [ ! -f $1 ]; then
   echo "$1: No existe el archivo"
   exit 1
fi

:<<'COMMENT'
struct  d_driver
{
    /* 
     * Changed the length of the name from 3 to 7 characters. 
     * 04/30/99 - rcm 
     * char name[ 4 ]; 
     */
    char    name[ 10 ];     /* driver's initials    */
    char    flag;           /* I = in unit 
                           O = out of unit 
                       U = unavailable  */
    /* 
     * Added this flag to identify company or driver vehicle. 
     * 04/30/99 - rcm 
     */
    char    cov;            /* C = Company owned vehicle 
                               P = Driver (privately) owned vehicle */
    short   login;          /* login time       */
    short   logout;         /* logout time      */
    long    odometin;       /* odometer: login time */
    long    odometout;      /* odometer: logout time*/
    long    cash;           /* cash fund        */
    long    expense1;       /* expenses - 1     */
    long    expense2;       /* expense - 2      */
    long    paid;           /* paid to driver/cmpny */
    long    sales;          /* gross - promo    */
    long    spromo;         /* surprise promo   */
    short   porders;        /* POV orders       */
    short   corders;        /* COV orders       */
    long    rate;           /* rate per journey */
    long    mirate;         /* mirate per mile  */
    short   fcash;          /* first order for cashout */
    short   lcash;          /* last order for cashout  */
    short   flog;           /* first order for logout  */
    short   llog;           /* last order for logout   */
    /* needed for creating Service Promise datafile    */
    int OrderCount;
    /* added for Service Promise Feature */
    short coup_issued;  /* Vouchers given at login */
    short doorstep;     /* Vouchers issued by the driver at
                        the door */
    short coup_return;  /* Vouchers turned in by the
                           driver at logout */
};

COMMENT

fmt="s10"            # char    name[ 10 ];
fmt="${fmt}c"        # char    flag;
fmt="${fmt}c"        # char    cov;
fmt="${fmt}h"        # short   login;
fmt="${fmt}h"        # short   logout;
fmt="${fmt}l"        # long    odometin;
fmt="${fmt}l"        # long    odometout;
fmt="${fmt}l"        # long    cash;
fmt="${fmt}l"        # long    expense1;
fmt="${fmt}l"        # long    expense2;
fmt="${fmt}l"        # long    paid;
fmt="${fmt}l"        # long    sales;
fmt="${fmt}l"        # long    spromo;
fmt="${fmt}h"        # short   porders;
fmt="${fmt}h"        # short   corders;
fmt="${fmt}l"        # long    rate; 
fmt="${fmt}l"        # long    mirate;
fmt="${fmt}h"        # short   fcash;
fmt="${fmt}h"        # short   lcash;
fmt="${fmt}h"        # short   flog;
fmt="${fmt}h"        # short   llog;
fmt="${fmt}u"        # int     OrderCount;
fmt="${fmt}h"        # short   coup_issued;
fmt="${fmt}h"        # short   doorstep;
fmt="${fmt}hp2"        # short   coup_return;


/usr/fms/etc/sysdd btoa ${fmt} $1

exit $?
