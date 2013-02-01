#########################################################################################
# Description:  Use MCP23017
# Created       Wed Jan 09 00:01:41 2013
# svn id        $Id: mcp23017.pl 439 2013-01-30 04:09:14Z Mark Dootson $
# Copyright:    Copyright (c) 2013 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

use strict;
use warnings;
use HiPi::MCP23017;
use Time::HiRes qw( usleep );

# 8 LEDs connected to 8 pins of Port A.
# Switch all off then switch on in order

my $mcp = HiPi::MCP23017->new();

my @bits = (0,0,0,0,0,0,0,0);
$mcp->write_register_bits('IODIRA', @bits);
$mcp->write_register_bits('GPIOA', @bits);
for(my $i = 0; $i < 8; $i ++) {
        @bits = $mcp->read_register_bits('GPIOA');
        $bits[$i] = 1;
        $mcp->write_register_bits('GPIOA', @bits);
        usleep( 500000 );
}
@bits = (0,0,0,0,0,0,0,0);
$mcp->write_register_bits('GPIOA', @bits);

1;
