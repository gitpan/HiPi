#########################################################################################
# Package       HiPi::Control::LCD::HD44780
# Description:  Direct PIN  HD44780 Controller
# Created       Sat Nov 24 20:48:42 2012
# SVN Id        $Id: HD44780.pm 422 2012-12-11 23:58:10Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Control::LCD::HD44780;

#########################################################################################

use strict;
use warnings;
use HiPi::Control::LCD;
use base qw( HiPi::Control::LCD );
use feature qw( switch );
use Carp;

sub new {
    my ($class, $pinRS, $pinE, $pinD4, $pinD5, $pinD6, $pinD7, $systemdevice) = @_;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub send_text {
    my($self, $text) = @_;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}

sub send_command {
    my($self, $command) = @_;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}

sub send_special_command {
    my($self, $command) = @_;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}

sub backlight {
    my($self, $brightness) = @_;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}

sub update_baudrate {
    my $self = shift;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}

sub update_geometry {
    my $self = shift;
    croak('Sorry - HiPi::Control::LCD::HD44780 not yet implemented');
}


1;
