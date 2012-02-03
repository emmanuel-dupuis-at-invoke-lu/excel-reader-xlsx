package Excel::Reader::XLSX::Worksheet;

###############################################################################
#
# Worksheet - A class for reading the Excel XLSX sheet.xml file.
#
# Used in conjunction with Excel::Reader::XLSX
#
# Copyright 2012, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Carp;
use XML::LibXML::Reader;
use Excel::Reader::XLSX::Row;
use Excel::Reader::XLSX::Package::XMLreader;

our @ISA     = qw(Excel::Reader::XLSX::Package::XMLreader);
our $VERSION = '0.00';

our $FULL_DEPTH  = 1;
our $RICH_STRING = 1;


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $self  = Excel::Reader::XLSX::Package::XMLreader->new();

    $self->{_reader} = undef;

    bless $self, $class;

    return $self;
}


###############################################################################
#
# next_row()
#
# Read the next available row in the worksheet.
#
sub next_row {

    my $self = shift;
    my $row  = undef;

    my $has_row = $self->{_reader}->nextElement( 'row' );

    if ( $has_row ) {
        $row = Excel::Reader::XLSX::Row->new( $self->{_reader} );
    }

    return $row;
}
###############################################################################
#
# name()
#
# TODO
#
sub name {

    my $self = shift;

    return $self->{_name};
}


###############################################################################
#
# _range_to_rowcol($range)
#
# TODO.
#
sub _range_to_rowcol {

    my $range = shift;

    $range =~ /([A-Z]{1,3})(\d+)/;

    my $col = $1;
    my $row = $2;

    # Convert base26 column string to number.
    my @chars = split //, $col;
    my $exponent = 0;
    $col = 0;

    while ( @chars ) {
        my $char = pop @chars;    # LS char first
        $col += ( ord( $char ) - ord( 'A' ) + 1 ) * ( 26**$exponent );
        $exponent++;
    }

    # Convert 1-index to zero-index
    $row--;
    $col--;

    return $row, $col;
}


1;


__END__

=pod

=head1 NAME

Worksheet - A class for reading the Excel XLSX sheet.xml file.

=head1 SYNOPSIS

See the documentation for L<Excel::Reader::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Reader::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MMXII, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Reader::XLSX>.

=cut
