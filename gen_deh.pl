#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
  if $running_under_some_shell;

# this emulates #! processing on NIH machines.
# (remove #! line above if indigestible)

eval '$' . $1 . '$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift;

# process any FOO=bar switches

$store     = $ENV{'STORE'};
$emp_map   = $ENV{'EMP_MAP'};
$ldesc_map = $ENV{'LDESC_MAP'};

#print "store: $store, emp_map: $emp_map, ldesc_map: $ldesc_map\n";

##
##	Module : %M%	        Date: %E%   Time: %U%
##			Daily transactions Script Module
##
##	Release : %R%.%L%
##	Version : %B%.%S%
##	Delta Time-Date : %E% %U%
##	%Z% %M% - %E% rel %R%.%L% ver %B%.%S%
##
##
## gen_deh.s - This program generates a "deh" file just like ARMS POS does
##

$[ = 1;       # set array base to 1
$, = ' ';     # set output field separator
$\ = "\n";    # set output record separator

$FS = '|';
$,  = ',';

# MEXICO - LINUX Define unit number as 5 digits
$store = sprintf( '%05d', $store );

# Get cross reference between Job descriptions
while ( ( ( $line = &Getline3($ldesc_map), $getline_ok ) ) > 0 ) {
    @args = split( /\|/, $line, -1 );
    $LDESC_MAP{ int( $args[1] ) } = $args[2];
}
delete $opened{$ldesc_map} && close($ldesc_map);

# Get cross reference between rfc and employee number
while ( ( ( $line = &Getline3($emp_map), $getline_ok ) ) > 0 ) {
    @args = split( /\|/, $line, -1 );
    $NO_EMP{ $args[2] } = $args[3];
}
delete $opened{$emp_map} && close($emp_map);

line: while (<>) {
    (
        $Fld1, $Fld2, $Fld3, $Fld4,  $Fld5, $Fld6,
        $Fld7, $Fld8, $Fld9, $Fld10, $Fld11
    ) = split( /[|\n]/, $_, -1 );

    $trn_rfc  = $Fld1;
    $trn_type = $Fld2;
    $trn_date = $Fld5;    # MM-DD-AA
    $trn_time = $Fld6;
    $trn_pos  = $Fld7;
    $trn_reas = $Fld8;
    $trn_hour = $Fld11;

    if (   $trn_type eq 'ML'
        || $trn_type eq 'TP'
        || $trn_type eq 'OT'
        || $trn_type eq 'NC' )
    {
        next line;
    }

    # Check employee time in
    if ( $trn_type eq 'TI' ) {
        $time_in_flg{$trn_rfc} = 1;
        $time_in{$trn_rfc}     = $trn_time;
        $in_date{$trn_rfc}     = $trn_date;
        next line;
    }

    # Check employee time out
    if ( $time_in_flg{$trn_rfc} == 1 && $trn_type eq 'TO' ) {
        $ti_hr =
          substr( $time_in{$trn_rfc}, 1, 2 ) +
          substr( $time_in{$trn_rfc}, 4, 2 ) / 60;
        $to_hr = substr( $trn_time, 1, 2 ) + substr( $trn_time, 4, 2 ) / 60;

        # if time out was the next day
        $in_date_ok =
            &get_year( substr( $in_date{$trn_rfc}, 7, 2 ) )
          . substr( $in_date{$trn_rfc}, 1, 2 )
          . substr( $in_date{$trn_rfc}, 4, 2 );
        $trn_date_ok =
            &get_year( substr( $trn_date, 7, 2 ) )
          . substr( $trn_date, 1, 2 )
          . substr( $trn_date, 4, 2 );

        if ( $in_date_ok lt $trn_date_ok ) {    #???
            $to_hr += 24;

        }
        $trn_hr = sprintf( '%.2f', $to_hr - $ti_hr );

        &print_deh( $trn_rfc, $trn_time );
        $time_in_flg{$trn_rfc} = 0;
        next line;
    }

    if ( $trn_type ne 'TO' && $trn_type ne 'TI' ) {
        &print_deh_esp();
    }
}

# check if everybody has a TO for this day
foreach $i ( keys %time_in_flg ) {
    if ( $time_in_flg{$i} == 1 ) {
        $trn_hr = sprintf( '%.2f', 0.0 );
        &print_deh( $i, '--:--' );
        $time_in_flg{$i} = 0;
    }
}

sub get_year {
    local ($yy) = @_;    # Regresa el a&o con 4 digitos
    if ( $y2k{$yy} eq '' ) {
        'get_year.s ' . ( $yyyy = &Getline3( $yy, '|' ), $getline_ok );
        delete $opened{ 'get_year.s ' . $yy } && close( 'get_year.s ' . $yy );
        $y2k{$yy} = $yyyy;
    }
    $y2k{$yy};
}

sub print_deh {
    local ( $rfc, $out_time ) = @_;
    local $entry_type = 0;
    if ( $NO_EMP{$rfc} eq '' ) {

        # Eliminate employees without number
        $elim++;
    }
    else {
        $entry_type = &get_EntryType( $NO_EMP{$rfc}, $in_date{$rfc}, $time_in{$rfc}, $out_time, $rfc );
        if ( $LDESC_MAP{$trn_pos} ne '' ) {
            print $store, $NO_EMP{$rfc}, $entry_type, $in_date{$rfc},
              $LDESC_MAP{$trn_pos}, $time_in{$rfc}, $out_time, $trn_hr, 'H', '';
        }
        else {
            print $store, $NO_EMP{$rfc}, $entry_type, $in_date{$rfc}, $trn_pos,
              $time_in{$rfc}, $out_time, 0, 'H', '';
        }
    }
}

sub print_deh_esp {
    if ( $NO_EMP{$trn_rfc} eq '' ) {
        $elim++;
    }
    elsif ( $LDESC_MAP{$trn_pos} ne '' ) {
        print $store, $NO_EMP{$trn_rfc}, '  ', $trn_date, $LDESC_MAP{$trn_pos},
          '00:00', '00:00', $trn_hour, $trn_type, '0', 'H', '';
    }
    else {
        print $store, $NO_EMP{$trn_rfc}, '  ', $trn_date, $trn_pos, '00:00',
          '00:00', $trn_hour, $trn_type, '0', 'H', '';
    }
}

sub Getline3 {
    &Pick( '', @_ );
    local ($_);
    if ( $getline_ok = ( ( $_ = <$fh> ) ne '' ) ) {
        ;
    }
    $_;
}

sub Pick {
    local ( $mode, $name, $pipe ) = @_;
    $fh = $name;
    open( $name, $mode . $name . $pipe ) unless $opened{$name}++;
}

sub get_EntryType {
    local ( $no_empl, $date, $timein, $timeout, $rfc ) = @_;
    ( $month, $day, $year ) = split( '-', $date );
    $date_id = "20$year-$month-$day";

    $status = `psql -U postgres -d dbeyum -A -t -c "SELECT entry_type FROM pp_emp_check WHERE date_id='$date_id' AND emp_num='$no_empl'"`;
    chomp( $status );
    

    return $status;
}
