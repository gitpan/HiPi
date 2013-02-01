#########################################################################################
# Package       HiPi::Threads
# Description:  Thread handler for HiPi
# Created       Fri Nov 23 11:40:51 2012
# SVN Id        $Id: Threads.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Threads;

#########################################################################################

=head1 NAME

HiPi::Threads

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :raspberry :pinmode :serial
        :spi :i2c :wiring :bcm2835 :mcp23017 :htv2cmd
        :htv2baudrate );
        
    use HiPi::BCM2835 qw( :registers :memory :function
        :pud :pad :pins :spi :pwm);
        
    use HiPi::GPIO::PAD1;
    use HiPi::GPIO::PAD5;
    use HiPi::Wiring;
    use HiPi::Control::LCD::HTBackpackV2
    use HiPi::Control::LCD::SerLCD
    use HiPi::MCP23017;
    use HiPi::cpuinfo;

=head1 DESCRIPTION

This module is not normally used directly in end user code
    
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

use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;
use Time::HiRes;
# create thread handling here



1;