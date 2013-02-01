#########################################################################################
# Description:  Drive Serial Connected LCD Module
# Created       Tue Jan 08 23:54:26 2013
# svn id        $Id: seriallcd.pl 450 2013-02-01 08:38:50Z Mark Dootson $
# Copyright:    Copyright (c) 2013 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

use strict;
use warnings;
use HiPi::Control::LCD::HTBackpackV2;
# use HiPi::Control::LCD::SerLCD;

my $hp = HiPi::Control::LCD::HTBackpackV2->new( { width => 16, lines => 4, backlightcontrol => 1, devicetype => 'serialrx' } );
#my $hp = HiPi::Control::LCD::SerLCD->new( { width => 16, lines => 2, backlightcontrol => 1, devicetype => 'serialrx' } );

my $epoch = 'Epoch ' . time();
$hp->enable(1);
		
$hp->backlight(25);
$hp->clear;

$hp->set_cursor_position(0,0);
$hp->send_text('Raspberry Pi');

$hp->set_cursor_position(0,1);
# $hp->send_text('SerLCD Control');
$hp->send_text('HT Backpack V2');

$hp->set_cursor_position(0,2);
$hp->send_text('Hitachi Control');

$hp->set_cursor_position(0,3);
$hp->send_text($epoch);


1;
