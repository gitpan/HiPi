#########################################################################################
# Package       HiPi::GPIO::PAD5
# Description:  Access Raspberry Pi GPIO PAD5
# Created       Fri Nov 23 19:49:18 2012
# SVN Id        $Id: PAD5.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::GPIO::PAD5;

#########################################################################################

=head1 NAME

HiPi::GPIO::PAD5

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :pinmode );
    use HiPi::GPIO::PAD5;
   
    my $pad5 = HiPi::GPIO::PAD5->new;
    
    # Set RPi Pad 5 header pins 3 & 4 to output and value high
    
    for ( 3, 4 ) {
        $pad5->set_pin_mode($_, PIN_MODE_OUTPUT);
        $pad5->set_pin($_);
    }
     ...

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
    
    # for the new method we pass an array representing the
    # BCM pin number translations for the PAD pin numbers.
    # e.g Rasbperry PAD5 pin 3 == BCM pin 28
    # We pass undef for non-accessible pins
    
    my $self = $class->SUPER::new(
        # pad to bcm2835 translations
        #  bcm2835 value         pad pin      wiringPi
        [
            undef, undef,       # 1   2       
            28,    29,          # 3   4       17    18
            30,    31,          # 5   6       19    20
            undef, undef,       # 7   8       
        ],
    );
    return $self;
}

1;
