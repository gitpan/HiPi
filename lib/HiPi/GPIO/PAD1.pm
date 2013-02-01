#########################################################################################
# Package       HiPi::GPIO::PAD1
# Description:  Access Raspberry Pi GPIO PAD1
# Created       Fri Nov 23 19:49:18 2012
# SVN Id        $Id: PAD1.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::GPIO::PAD1;

#########################################################################################

=head1 NAME

HiPi::GPIO::PAD1

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :pinmode );
    use HiPi::GPIO::PAD1;
   
    my $pad1 = HiPi::GPIO::PAD1->new;
    
    # Set RPi Pad 1 header pins 8 & 10 to output and value high
    
    for ( 8, 10 ) {
        $pad1->set_pin_mode($_, PIN_MODE_OUTPUT);
        $pad1->set_pin($_);
    }
     ...
     ...
    
    # we used the standard UART pins so we ought to set
    # them back to defaults
    
    $pad1->prepare_UART0();

=head1 DESCRIPTION

See pod for HiPi::GPIO for full usage and methods.
    
=head1 LICENSE

This work is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 3 of the License, or any later 
version.

=head3 License Note

I would normally release any Perl code under the Perl Artistic License
but this module wraps several GPL / LGPL C libraries and I feel that
the licensing of the entire distribution is simpler if the Perl code
is under GPL too.

=head1 AUTHOR

Mark Dootson, C<< <mdootson at cpan.org> >>

=head1 COPYRIGHT

Copyright (C) 2012-2013 Mark Dootson, all rights reserved.

=cut

use HiPi;
use strict;
use warnings;
use parent qw( HiPi::GPIO );

sub new {
    my $class = shift;
    
    # variations due to PiBoard revision
    my $_piboard_is2 = ( HiPi::cpuinfo::get_piboard_rev == 2 ) ? 1 : 0;
    my $pin3  = ( $_piboard_is2 ) ? 2 : 0;
    my $pin5  = ( $_piboard_is2 ) ? 3 : 1;
    my $pin13 = ( $_piboard_is2 ) ? 27 : 21;
    
    # for the new method we pass an array representing the
    # BCM pin number translations for the PAD pin numbers.
    # e.g Rasbperry PAD1 pin 7 == BCM pin 4
    # We pass undef for non-accessible pins
    
    my $self = $class->SUPER::new(
        # pad to bcm2835 translations
        #  bcm2835 value         pad pin     wiringPi
        [
            undef, undef,       # 1   2       
            $pin3, undef,       # 3   4       8
            $pin5, undef,       # 5   6       9
            4,     14,          # 7   8       7    15
            undef, 15,          # 9   10           16
            17,    18,          # 11  12      0     1
            $pin13,undef,       # 13  14      2
            22,    23,          # 15  16      3     4
            undef, 24,          # 17  18            5
            10,    undef,       # 19  20     12
            9,     25,          # 21  22     13     6
            11,    8,           # 23  24     14    10
            undef, 7,           # 25  26           11
        ],
    );
    return $self;
}

1;
