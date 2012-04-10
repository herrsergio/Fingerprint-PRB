#!/bin/bash

# tkpaytrn.dat binary file to ascii

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



USAGE="Usage: $0 tkpaytrn.dat [ > tkpay_ascii_file ]"
if [ $# -ne 1 -o "$1" = "-h" ]; then
   echo $USAGE
   exit 1
fi
if [ ! -f $1 ]; then
   echo "$1: No existe el archivo"
   exit 1
fi

:<<'COMMENT'
typedef struct tranqty
{
    float   hrs;                    /* (   ) */
    float   dols;                   /* (   ) */
    short   s_int;                  /* (   ) */
    char    fill1[2];               /* (   ) */
} TRANQTY;

typedef struct  tkpaytrn_rec
{
    long    date;                   /* (   ) */
    short   tran_group;             /* (   ) */
    char    fill1[2];               /* (   ) */
    char    emp_ssn[16];                /* (   ) */
    char    source;                 /* (   ) */
    char    trancode[3];                /* (   ) */
    char    pay_type[3];                /* (   ) */
    char    dept[3];                /* (   ) */
    short   pay_rate;               /* (   ) */
    char    labor_desc[3];              /* (   ) */
    char    ot_type;                /* (   ) */
    short   week;                   /* (   ) */
    char    shift;                  /* (   ) */
    char    cost_unit_override[7];          /* (   ) */
    char    fill2[2];               /* (   ) */
    long    last_change_date;           /* (   ) */
    char    last_user[2];               /* (   ) */
    char    delete_flag;                /* (   ) */
    char    reason_code;                /* (   ) */
    struct  tranqty qty;                /* (   ) */
} TKPAYTRN_REC;
COMMENT

fmt="l"              # long    date;	
fmt="${fmt}h"        # short   tran_group;
fmt="${fmt}s2"       # char    fill1[2];
fmt="${fmt}s16"      # char    emp_ssn[16];
fmt="${fmt}c"        # char    source;
fmt="${fmt}s3"       # char    trancode[3];
fmt="${fmt}s3"       # char    pay_type[3]; 
fmt="${fmt}s3"       # char    dept[3];
fmt="${fmt}h"        # short   pay_rate;
fmt="${fmt}s3"       # char    labor_desc[3];
fmt="${fmt}c"        # char    ot_type; 
fmt="${fmt}h"        # short   week;
fmt="${fmt}c"        # char    shift;
fmt="${fmt}s7"       # char    cost_unit_override[7];
fmt="${fmt}s2"       # char    fill2[2]; 
fmt="${fmt}l"        # long    last_change_date;
fmt="${fmt}s2"       # char    last_user[2]; 
fmt="${fmt}c"        # char    delete_flag; 
fmt="${fmt}c"        # char    reason_code; 
                     # struct  tranqty qty
fmt="${fmt}f"        # float   hrs;
fmt="${fmt}f"        # float   dols;
fmt="${fmt}h"        # short   s_int;
fmt="${fmt}s2"       # char    fill1[2];


/usr/fms/etc/sysdd btoa ${fmt} $1

exit $?
