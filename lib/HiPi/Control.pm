#########################################################################################
# Package       HiPi::Control
# Description:  Base class for all controls
# Created       Sat Nov 24 15:48:14 2012
# SVN Id        $Id: Control.pm 451 2013-02-01 19:44:12Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Control;

#########################################################################################

=head1 NAME

HiPi::Control

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
use HiPi;
use HiPi::Class;
use base qw( HiPi::Class );

our $VERSION = '0.01';

__PACKAGE__->create_accessors( qw( name ) );

sub new {
    my( $class, $params ) = @_;
    $params->{name} ||= $class;
    return $class->SUPER::new( $params );
}


1;
