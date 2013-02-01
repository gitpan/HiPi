#########################################################################################
# Package       HiPi::Constant::BoardRev1
# Description:  Constants for Raspberry Pi board revision 1
# Created       Fri Nov 23 22:32:56 2012
# SVN Id        $Id: BoardRev1.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Constant::BoardRev1;

#########################################################################################

use strict;
use warnings;

our $VERSION = '0.01';

package HiPi::Constant;

use strict;
use warnings;

#-------------------------------------------
# Constants to convert RPI pin ids
# to Broadcom Pin numbers
#-------------------------------------------

use constant {
    RPI_HIGH                =>  1,
    RPI_LOW                 =>  0,
    RPI_BOARD_REVISION      =>  1,
    RPI_TOGPIO_P1_3         =>  0,
    RPI_TOGPIO_P1_5         =>  1,
    RPI_TOGPIO_P1_7         =>  4,
    RPI_TOGPIO_P1_8         => 14,
    RPI_TOGPIO_P1_10        => 15,
    RPI_TOGPIO_P1_11        => 17,
    RPI_TOGPIO_P1_12        => 18,
    RPI_TOGPIO_P1_13        => 21,
    RPI_TOGPIO_P1_15        => 22,
    RPI_TOGPIO_P1_16        => 23,
    RPI_TOGPIO_P1_18        => 24,
    RPI_TOGPIO_P1_19        => 10,
    RPI_TOGPIO_P1_21        =>  9,
    RPI_TOGPIO_P1_22        => 25,
    RPI_TOGPIO_P1_23        => 11,
    RPI_TOGPIO_P1_24        =>  8,
    RPI_TOGPIO_P1_26        =>  7,
};

our @_RPI_TOGPIO_const = qw(
    RPI_HIGH RPI_LOW RPI_BOARD_REVISION
    RPI_TOGPIO_P1_3  RPI_TOGPIO_P1_5  RPI_TOGPIO_P1_7  RPI_TOGPIO_P1_8 
    RPI_TOGPIO_P1_10 RPI_TOGPIO_P1_11 RPI_TOGPIO_P1_12 RPI_TOGPIO_P1_13
    RPI_TOGPIO_P1_15 RPI_TOGPIO_P1_16 RPI_TOGPIO_P1_18 RPI_TOGPIO_P1_19
    RPI_TOGPIO_P1_21 RPI_TOGPIO_P1_22 RPI_TOGPIO_P1_23 RPI_TOGPIO_P1_24 
    RPI_TOGPIO_P1_26
    );

1;