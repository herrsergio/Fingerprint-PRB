#!/usr/bin/perl

use lib '/usr/bin/ph/perllib/share/perl/5.8.4';
use lib '/usr/bin/ph/perllib/lib/perl/5.8.4';
use lib '/usr/bin/ph/fingerprint/lib';

use HTML::TableExtract;

sub clean_table {
    my @table = @_;

    # No se necesita parsear los renglones que tengan estos datos
    for my $i ( reverse 0 .. $#table ) {
        splice @table, $i, 1 if $table[$i] =~ /Copyright/;
        splice @table, $i, 1 if $table[$i] =~ /Period/;
        splice @table, $i, 1 if $table[$i] =~ /Date/;
        splice @table, $i, 1 if $table[$i] =~ /Today/;
        splice @table, $i, 1 if $table[$i] =~ /Yesterday/;
        splice @table, $i, 1 if $table[$i] =~ /week/;
        splice @table, $i, 1 if $table[$i] =~ /month/;
        splice @table, $i, 1 if $table[$i] =~ /to/;
        splice @table, $i, 1 if $table[$i] =~ /Report/;
        splice @table, $i, 1 if $table[$i] =~ /Department/;
    }

    # Se regresan los renglones
    return @table;
}

sub parse_ids {
    @array = @_;

    chomp($today);

    $num_records = 1;
    $options1 = "action=run&sdate=$today&edate=$today&";

    foreach $line (@array) {
        chomp($line);
        chop($line);

        if ( $line =~ m/,,/ ) {
            #print "line2 = $line\n";
            @info = split ( ',', $line );
            if( $display == 0 ) {
                $options = $options1 . "uid=$num_records";
                print "$options\n";
                $num_records++;
			} else {
                print "$info[2]\n";
			}
        }

        
    }

}

$numArgs = $#ARGV + 1;

if ( $numArgs < 2 ) {
    die "Uso: $0 FILE.html YYYY-MM-DD [1\|0]\n1 es para desplegar ids, 0 es para desplegar options del url\n";
}

$file = $ARGV[0];

$today = $ARGV[1];

$display = $ARGV[2];

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

#print "data:\n";
#print "@data\n";
#@clean_data = clean_table(@data);
#print "clean_data:\n";
#print "@clean_data\n";

parse_ids(@data);

