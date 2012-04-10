#!/usr/bin/perl

use lib "/usr/bin/ph/fingerprint/lib";
use lib '/usr/bin/ph/perllib/share/perl/5.8.4';
use lib '/usr/bin/ph/perllib/lib/perl/5.8.4';

use lib "/usr/bin/ph/databases/posdb/lib";

use posdb;
use HTML::TableExtract;
use Time::Simple;
use Log::Log4perl;
#use Log::Dispatch::FileRotate;

my $log_conf = q/ 
    log4perl.category = INFO, Logfile
     
    log4perl.appender.Logfile = Log::Log4perl::Appender::File
    log4perl.appender.Logfile.filename = \/usr\/bin\/ph\/fingerprint\/logs\/parseFP.log 
    log4perl.appender.Logfile.mode = append
    log4perl.appender.Logfile.layout = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.Logfile.layout.ConversionPattern = %d %p: %M> %m%n

     
/;

Log::Log4perl::init( \$log_conf );
$logger = Log::Log4perl::get_logger();

sub clean_table {
    my @table = @_;

    # No se necesita parsear los renglones que tengan estos datos
    for my $i ( reverse 0 .. $#table ) {
        splice @table, $i, 1 if $table[$i] =~ /Data/;
        splice @table, $i, 1 if $table[$i] =~ /Date/;
        splice @table, $i, 1 if $table[$i] =~ /\.\.\./;
    }

    # Se regresan los renglones
    return @table;
}

sub fill_hrcempl_data {
    my ( $emp_id, $time_in, $time_out, $date_id, $pt ) = @_;

    if ( $time_out eq "" ) {
        $action = "TI";
        $logger->info("Action = $action");

        if ( $pt == 1 ) {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timein1) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        else {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timein2) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        $query->execute();
        $time_in_epoch = $query->fetchrow();
    }
    else {
        $action = "TO";
        $logger->info("Action = $action");

        if ( $pt == 1 ) {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timeout1) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        else {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timeout2) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        $query->execute();
        $time_out_epoch = $query->fetchrow();
    }

    #print "emp_id: $emp_id, time_in: $time_in, time_out: $time_out\n";

    #$action = "TI";

    open( COMM,
        "/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat |" );
    while (<COMM>) {

        #chomp($_);
        #chop($_);
        $data       = $_;
        @info       = split( /\|/, $data );
        $emp_name   = $info[0];
        $emp_num    = $info[1];
        $emp_rfc    = $info[2];
        $emp_dpt    = $info[3];
        $emp_puesto = $info[4];
        chop($emp_puesto);

        if ( $emp_num eq $emp_id ) {
            if ( $action eq "TI" ) {
`/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch`;
               # print
#"/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch\n";
                $logger->info("Ejecutando: /usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch");
            }
            else {
`/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch`;
                #print
#"/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch\n";
                $logger->info("Ejecutando: /usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch");
            }
            last;
        }

    }
    close(COMM);

}

sub fill_hrcempl_data_dawn {
    my ( $emp_id, $time_in, $time_out, $date_id, $pt ) = @_;
    
    $todayAAMMDD = substr($date_id, 2, 8);
    chomp( $todayAAMMDD );
    $timeout1 = "20".$todayAAMMDD . " " . $dawn_hour;
    $dant = `/usr/bin/ph/dant.s $todayAAMMDD`;
    chomp( $dant );
    $dant20 = "20". $dant;

    if ( $time_out eq "" ) {
        $action = "TI";
        $logger->info("Action = $action");

        if ( $pt == 1 ) {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timein1) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        else {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timein2) FROM pp_emp_check where date_id='$date_id' AND emp_num='$emp_id'"
            );
        }
        $query->execute();
        $time_in_epoch = $query->fetchrow();
    }
    else {
        $action = "TO";
        $logger->info("Action = $action");

        if ( $pt == 1 ) {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timeout1) FROM pp_emp_check where date_id='$dant20' AND emp_num='$emp_id'"
            );
        }
        else {
            $query = $dbh->prepare(
"SELECT extract(epoch FROM timeout2) FROM pp_emp_check where date_id='$dant20' AND emp_num='$emp_id'"
            );
        }
        $query->execute();
        $time_out_epoch = $query->fetchrow();
    }

    #print "emp_id: $emp_id, time_in: $time_in, time_out: $time_out\n";

    #$action = "TI";

    open( COMM,
        "/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat |" );
    while (<COMM>) {

        #chomp($_);
        #chop($_);
        $data       = $_;
        @info       = split( /\|/, $data );
        $emp_name   = $info[0];
        $emp_num    = $info[1];
        $emp_rfc    = $info[2];
        $emp_dpt    = $info[3];
        $emp_puesto = $info[4];
        chop($emp_puesto);

        if ( $emp_num eq $emp_id ) {
            if ( $action eq "TI" ) {
`/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch`;
               # print
#"/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch\n";
                $logger->info("Ejecutando: /usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_in_epoch");
            }
            else {
`/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch`;
                #print
#"/usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch\n";
                $logger->info("Ejecutando: /usr/bin/ph/fingerprint/bin/clock_employee.sh $emp_num $emp_rfc $emp_dpt $emp_puesto $action $time_out_epoch");
            }
            last;
        }

    }
    close(COMM);

}

sub diff_hours {
    my ( $t1, $t2 ) = @_;
    $time1 = Time::Simple->new($t1);
    $time2 = Time::Simple->new($t2);
    $diff  = Time::Simple->new;

    $diff = $time2 - $time1;

    return $diff;

}

sub check_entry_tkpaytrn {
    # date: yyyy-mm-dd necesita ser yy-mm-dd
    ( $io, $rfc, $date ) = @_;
    $date = substr($date, 2, 9);
    $checks =
#`/usr/bin/ph/fingerprint/bin/tkpay2ascii.s  /usr/fms/data/tkpaytrn.dat \| grep $rfc \| grep $io \| wc -l`;
`/usr/bin/ph/sdc_deh/bin/tkpay /usr/fms/data/tkpaytrn.dat \| grep $rfc \| grep $io \| grep $date \| wc -l`;
    chomp($checks);
    return $checks;
}

sub check_entry_database {
    ( $column, $date, $emp_id ) = @_;
    $query = $dbh->prepare(
"SELECT $column FROM pp_emp_check WHERE date_id='$date' AND emp_num='$emp_id'"
    );
    $query->execute();
    $res = $query->fetchrow();
    return $res;
}


sub fms_time_records {
    # date: yyyy-mm-dd necesita ser yy-mm-dd
    ( $io, $rfc, $date ) = @_;
    $date = substr($date, 2, 9);
    my @times;
    @t =
`/usr/bin/ph/sdc_deh/bin/tkpay /usr/fms/data/tkpaytrn.dat \| grep $rfc \| grep $io \| grep $date \| cut -d\\| -f6`;
    foreach $h ( @t ) {
        chomp( $h );
        $res = "20".$date." ".$h.":00";
        push( @times, $res );
    }
    return \@times;
}

=pod
sub fms_time_records {
    ( $io, $rfc ) = @_;
    my @times;
    @epoch_times =
`/usr/bin/ph/fingerprint/bin/tkpay2ascii.s /usr/fms/data/tkpaytrn.dat \| grep $rfc \| grep $io \| cut -d\\| -f1`;
    foreach $epoch (@epoch_times) {
        chomp($epoch);
        $query = $dbh->prepare(
"SELECT TIMESTAMP WITHOUT TIME ZONE 'epoch' + $epoch * INTERVAL '1 second'"
        );
        $query->execute();
        $res = $query->fetchrow();
        push( @times, $res );
    }
    return \@times;
}
=cut

sub parse_hours {
    my @array = @_;

    $min_time_to = 2700;

    chomp($today);

    $dawn_flag = 0;

    foreach $line (@array) {
        chomp($line);
        chop($line);
        @info = split( ',', $line );
        #print "line: $line\n";
        $logger->info("line: $line");
        $id = $info[1];
        #print "1 id: $id, info[1] = $info[1]\n";
        $logger->info("1 id: $id, info[1] = $info[1]");
        $the_id = $id;
        $hour   = $info[3];
        push( @hours, $hour );
    }



    if ( $the_id ne "" ) {

        # Revisar por registros en la madrugada
        foreach $h ( @hours ) {
            ( $hr, $min, $sec ) = split( ":", $h );
            # Salida en la madrugada
            if ( "$hr" eq "00" || "$hr" eq "01" || "$hr" eq "02" || "$hr" eq "03" ) {
                $logger->info("Salida en la madrugada de $the_id");
                $dawn_flag = 1;
                #Se descuenta una lectura del fingerprint
                $num_checks_fingerprint--;
                $dawn_hour = $h;
                # Salida madrugada
                $todayAAMMDD = substr($today, 2, 8);
                chomp( $todayAAMMDD );
                $timeout1 = "20".$todayAAMMDD . " " . $dawn_hour;
                $dant = `/usr/bin/ph/dant.s $todayAAMMDD`;
                chomp( $dant );
                $dant20 = "20". $dant;
                $has_timeout1_db = check_entry_database( "timeout1", $dant20, $the_id );
                if ( !$has_timeout1_db ) {
                    $logger->info("Salida en la madrugada, no tiene aun salida");
                    $query    = $dbh->prepare(
"UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$dant20' AND emp_num = '$the_id'"
                    );
                    $logger->info("Query: UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$dant20' AND emp_num = '$the_id'");
                    $query->execute();
                    # LLenar registro en FMS
                    fill_hrcempl_data_dawn( $the_id, "", $timeout1, $today, 1 );
                }
            } 
        }

        if( $dawn_flag == 1) {
            shift( @hours );
        }

        $num_checks_fingerprint = $#hours + 1;


        $num_checks_fms_in  = check_entry_tkpaytrn( "TI", $empl_rfc{$the_id}, $today );
        $num_checks_fms_out = check_entry_tkpaytrn( "TO", $empl_rfc{$the_id}, $today );
        $has_timein1_db     = check_entry_database( "timein1",  $today, $the_id );
        $has_timein2_db     = check_entry_database( "timein2",  $today, $the_id );
        $has_timeout2_db    = check_entry_database( "timeout2", $today, $the_id );
        $has_timeout1_db    = check_entry_database( "timeout1", $today, $the_id );
        $times_in_tmp       = fms_time_records( "TI", $empl_rfc{$the_id}, $today );
        @times_in_fms       = @$times_in_tmp;
        $times_out_tmp      = fms_time_records( "TO", $empl_rfc{$the_id}, $today );
        @times_out_fms      = @$times_out_tmp;

        #print "Numero de checadas $num_checks_fingerprint\n";
        $logger->info("Numero de checadas $num_checks_fingerprint para $the_id");
        $query = $dbh->prepare("SELECT store_id FROM ss_cat_store");
        $query->execute();
        $store_id = $query->fetchrow();

        #$min_diff = diff_hours( $hours[$#hours], $hours[0] );
        #print "$the_id|$hours[0]|$hours[$#hours]|$min_diff\n";



        if ( $num_checks_fingerprint == 1 ) {
            $logger->info("Dentro de if una checada");
            if ( !$has_timein1_db ) {
                $timein1 = $today . " " . $hours[0];
                $query   = $dbh->prepare(
"INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')"
                );
                $query->execute();
                
                $logger->info("Ejecutando script: INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')");

                # LLenar registro en FMS
                fill_hrcempl_data( $the_id, $timein1, "", $today, 1 );
            }
        }

        if ( $num_checks_fingerprint == 2 ) {
            $logger->info("Dentro de if dos checadas");
            if ( !$has_timein1_db ) {
                $timein1 = $today . " " . $hours[0];
                $query   = $dbh->prepare(
"INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')"
                );
                $query->execute();

                $logger->info("INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')");

                # LLenar registro en FMS
                fill_hrcempl_data( $the_id, $timein1, "", $today, 1 );
            }
            $min_diff = diff_hours( $hours[1], $hours[0] );
            if ( !$has_timeout1_db ) {
                $logger->info("no tiene salida 1");
                if ( $min_diff > $min_time_to ) {
                    $timeout1 = $today . " " . $hours[1];
                    $query    = $dbh->prepare(
"UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();
                    $logger->info("Ejecutando query: UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$today' AND emp_num = '$the_id'");

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, "", $timeout1, $today, 1 );
                }
            }
        }

        if ( $num_checks_fingerprint == 3 ) {
            $logger->info("Tiene 3 checadas");
            if ( !$has_timein1_db ) {
                $timein1 = $today . " " . $hours[0];
                $query   = $dbh->prepare(
"INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')"
                );
                $query->execute();
                $logger->info("Ejecutando query: INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')");

                # LLenar registro en FMS
                fill_hrcempl_data( $the_id, $timein1, "", $today, 1 );
            }
            $min_diff = diff_hours( $hours[1], $hours[0] );
            if ( !$has_timeout1_db ) {
                if ( $min_diff > $min_time_to ) {
                    $timeout1 = $today . " " . $hours[1];
                    $query    = $dbh->prepare(
"UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();
                    $logger->info("Ejecutando query: UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$today' AND emp_num = '$the_id'");

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, "", $timeout1, $today, 1 );
                }
            }
            $min_diff = diff_hours( $hours[2], $hours[1] );
            if ( !$has_timein2_db ) {
                if ( $min_diff > $min_time_to ) { 
                    $timein2 = $today . " " . $hours[2];
                    $query   = $dbh->prepare(
"UPDATE pp_emp_check SET timein2 = timestamp '$timein2'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();
                    $logger->info("Ejecutando query: UPDATE pp_emp_check SET timein2 = timestamp '$timein2'  WHERE date_id = '$today' AND emp_num = '$the_id'");

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, $timein2, "", $today, 2 );
                }
            }
        }

        if ( $num_checks_fingerprint == 4 ) {
            if ( !$has_timein1_db ) {
                $timein1 = $today . " " . $hours[0];
                $query   = $dbh->prepare(
"INSERT INTO pp_emp_check (store_id, date_id, emp_num, timein1, entry_type) VALUES ($store_id, '$today', '$the_id', timestamp '$timein1', '0')"
                );
                $query->execute();

                # LLenar registro en FMS
                fill_hrcempl_data( $the_id, $timein1, "", $today, 1 );
            }
            $min_diff = diff_hours( $hours[1], $hours[0] );
            if ( !$has_timeout1_db ) {
                if ( $min_diff > $min_time_to ) {
                    $timeout1 = $today . " " . $hours[1];
                    $query    = $dbh->prepare(
"UPDATE pp_emp_check SET timeout1 = timestamp '$timeout1'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, "", $timeout1, $today, 1 );
                }
            }
            $min_diff = diff_hours( $hours[2], $hours[1] );
            if ( !$has_timein2_db ) {
                if ( $min_diff > $min_time_to ) { 
                    $timein2 = $today . " " . $hours[2];
                    $query   = $dbh->prepare(
"UPDATE pp_emp_check SET timein2 = timestamp '$timein2'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, $timein2, "", $today, 2 );
                }
            }
            $min_diff = diff_hours( $hours[3], $hours[2] );
            if ( !$has_timeout2_db ) {
                if( $min_diff > $min_time_to ) {
                    $timeout2 = $today . " " . $hours[3];
                    $query    = $dbh->prepare(
"UPDATE pp_emp_check SET timeout2 = timestamp '$timeout2'  WHERE date_id = '$today' AND emp_num = '$the_id'"
                    );
                    $query->execute();

                    # LLenar registro en FMS
                    fill_hrcempl_data( $the_id, "", $timeout2, $today, 2 );
                }
            }
        }
    }
}

$numArgs = $#ARGV + 1;

$logger->info("****** Iniciando ******");

if ( $numArgs != 2 ) {
    $logger->error("Uso: $0 FILE.html YYYY-MM-DD");
    die "Uso: $0 FILE.html YYYY-MM-DD\n";
}

$file = $ARGV[0];

$today = $ARGV[1];

$te = HTML::TableExtract->new();

$te->parse_file($file);

foreach $ts ( $te->tables ) {
    foreach $row ( $ts->rows ) {
        if ($row) {
            chomp($row);
            push( @data, join( ',', @$row, "\n" ) );
        }
    }
}

%empl_rfc = ();

open( COMM,
    "/usr/bin/ph/emplalt/bin/emplshowdata.s /usr/fms/data/hrcempl.dat |" );
while (<COMM>) {
    $data               = $_;
    @info               = split( /\|/, $data );
    $emp_num            = $info[1];
    $emp_rfc            = $info[2];
    $empl_rfc{$emp_num} = $emp_rfc;
}
close(COMM);

@clean_data = clean_table(@data);
#print "****************\n";
#print "clean_data\n";
#print "@clean_data\n";
#print "****************\n";
$logger->info("Clean data: @clean_data");
parse_hours(@clean_data);

$logger->info("****** Fin ******");
