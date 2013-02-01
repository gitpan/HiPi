#########################################################################################
# Description:  GPIO pins on PAD5
# Created       Wed Jan 09 00:05:42 2013
# svn id        $Id: gpio.pl 442 2013-01-31 03:11:05Z Mark Dootson $
# Copyright:    Copyright (c) 2013 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

use strict;
use warnings;
use HiPi::GPIO::PAD1;
use HiPi::Constant qw( :all );

# Assumes LED connected to pin 11

my $pad1 = HiPi::GPIO::PAD1->new;
$pad1->set_pin_mode(11, PIN_MODE_OUTPUT);
$pad1->set_pin(11);
$pad1->delay(1000);
$pad1->clr_pin(11);
$pad1->delay(1000);
$pad1->set_pin(11);
$pad1->delay(1000);
$pad1->clr_pin(11);

1;
