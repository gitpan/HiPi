#########################################################################################
# Package       HiPi::Apps::Control::Panel::GPIO1
# Description:  Base for data panels
# Created       Wed Feb 27 23:09:33 2013
# SVN Id        $Id: GPIO1.pm 1076 2013-03-13 08:55:10Z Mark Dootson $
# Copyright:    Copyright (c) 2013 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Apps::Control::Panel::GPIO1;

#########################################################################################

use strict;
use warnings;
use parent qw( HiPi::Apps::Control::Panel::Pad );
use Wx;
use HiPi::Apps::Control::Data::GPIOPAD1;

our $VERSION = '0.22';

sub new {
    my ($class, $parent) = @_;
    my $vdata = HiPi::Apps::Control::Data::GPIOPAD1->new;
    my $self = $class->SUPER::new($parent, $vdata, $vdata->padname);
    return $self;
}

1;
