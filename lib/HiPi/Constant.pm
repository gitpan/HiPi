#########################################################################################
# Package       HiPi::Constant
# Description:  Utility constants for HiPi
# Created       Fri Nov 23 22:23:29 2012
# SVN Id        $Id: Constant.pm 447 2013-02-01 04:57:06Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Constant;

#########################################################################################

=head1 NAME

HiPi::Constant 

=head1 VERSION

Version 0.02

=head1 SYNOPSYS

    use HiPi::Constant qw( :raspberry :pinmode :serial
        :spi :i2c :wiring :bcm2835 :mcp23017 :htv2cmd
        :htv2baudrate );
    
=head1 DESCRIPTION

Export constants for various HiPi:: modules

=head1 EXPORTED CONSTANT TAGS

=head2 :raspberry

High / Low pin level setting

    RPI_HIGH
    RPI_LOW
    
The current RPi board revision

    RPI_BOARD_REVISION
    
Constants to convert RPi pin header numbers to BCM GPIO pin numbers on
RPi PAD 1 and PAD 5. These are suitable to pass Rasperry Pi GPIO header
pin numbers to HiPi::BCM2835 functions.

    RPI_TOGPIO_P1_3
    RPI_TOGPIO_P1_5
    RPI_TOGPIO_P1_7
    RPI_TOGPIO_P1_8 
    RPI_TOGPIO_P1_10 
    RPI_TOGPIO_P1_11
    RPI_TOGPIO_P1_12
    RPI_TOGPIO_P1_13 
    RPI_TOGPIO_P1_15
    RPI_TOGPIO_P1_16 
    RPI_TOGPIO_P1_18
    RPI_TOGPIO_P1_19 
    RPI_TOGPIO_P1_21
    RPI_TOGPIO_P1_22
    RPI_TOGPIO_P1_23
    RPI_TOGPIO_P1_24
    RPI_TOGPIO_P1_26
    
    RPI_TOGPIO_P5_3
    RPI_TOGPIO_P5_4
    RPI_TOGPIO_P5_5
    RPI_TOGPIO_P5_6

=head2 :pinmode

    PIN_MODE_OUTPUT 
    PIN_MODE_INPUT

=head2 :serial

Constants to convert named RPi header pins to Raspberry Pi header
pin numbers. These are suitable for passing to HiPi::GPIO::PADx
methods as pin identifiers.

    UART0_TXD
    UART0_RXD
    UART0_RTS
    UART1_TXD
    UART1_RXD
    UART1_RTS

=head2 :spi

Constants to convert named RPi header pins to Raspberry Pi header
pin numbers. These are suitable for passing to HiPi::GPIO::PADx
methods as pin identifiers.

    SPI0_MOSI
    SPI0_MISO
    SPI0_CLK
    SPI0_SCLK
    SPI0_CEO_N
    SPI0_CE1_N

=head2 :i2c

Constants to convert named RPi header pins to Raspberry Pi header
pin numbers. These are suitable for passing to HiPi::GPIO::PADx
methods as pin identifiers.

    I2C0_SDA
    I2C0_SCL

=head2 :wiring

Constants to convert WiringPi pin numbers to Raspberry Pi header
pin numbers. These are suitable for passing to HiPi::GPIO::PADx
methods as pin identifiers. They may be useful when converting
code designed for the WiringPi library to use HiPi::GPIO::PADx
modules.

    WPI_PIN_0 
    WPI_PIN_1 
    WPI_PIN_2 
    WPI_PIN_3 
    WPI_PIN_4 
    WPI_PIN_5 
    WPI_PIN_6 
    WPI_PIN_7 
    WPI_PIN_8 
    WPI_PIN_9 
    WPI_PIN_10 
    WPI_PIN_11 
    WPI_PIN_12
    WPI_PIN_13 
    WPI_PIN_14 
    WPI_PIN_15 
    WPI_PIN_16
    WPI_PIN_17 
    WPI_PIN_18 
    WPI_PIN_19 
    WPI_PIN_20 
    
Constants to for HiPi::Wiring methods.
    
    WPI_NUM_PINS
    WPI_MODE_PINS
    WPI_MODE_GPIO
    WPI_MODE_GPIO_SYS
    WPI_MODE_PIFACE
    WPI_INPUT
    WPI_OUTPUT
    WPI_PWM_OUTPUT
    WPI_LOW
    WPI_HIGH
    WPI_PUD_OFF
    WPI_PUD_DOWN
    WPI_PUD_UP
    WPI_PWM_MODE_MS
    WPI_PWM_MODE_BAL
    WPI_NES_RIGHT
    WPI_NES_LEFT
    WPI_NES_DOWN
    WPI_NES_UP
    WPI_NES_START
    WPI_NES_SELECT
    WPI_NES_B
    WPI_NES_A

=head2 :bcm2835

Constants to convert BCM 2835 GPIO pin numbers to Raspberry Pi header
pin numbers. These are suitable for passing to HiPi::GPIO::PADx
methods as pin identifiers. They may be useful when converting
code designed for the bcm2835 library to use HiPi::GPIO::PADx
modules.

    BCM_0 
    BCM_1 
    BCM_4 
    BCM_7  
    BCM_8 
    BCM_9 
    BCM_10
    BCM_11 
    BCM_14 
    BCM_15
    BCM_17 
    BCM_18 
    BCM_21 
    BCM_22 
    BCM_23
    BCM_24
    BCM_25
    BCM_2
    BCM_3
    BCM_27 
    BCM_28
    BCM_29 
    BCM_30 
    BCM_31 

=head2 :mcp23017

Constants for use with HiPi::MCP23017

    MCP23017_A0
    MCP23017_A1 
    MCP23017_A2   
    MCP23017_A3   
    MCP23017_A4 
    MCP23017_A5 
    MCP23017_A6 
    MCP23017_A7 
    MCP23017_B0 
    MCP23017_B1 
    MCP23017_B2 
    MCP23017_B3 
    MCP23017_B4 
    MCP23017_B5 
    MCP23017_B6 
    MCP23017_B7 
    
    MCP23017_BANK 
    MCP23017_MIRROR
    MCP23017_SEQOP
    MCP23017_DISSLW
    MCP23017_HAEN 
    MCP23017_ODR
    MCP23017_INTPOL


=head2 :htv2cmd

Constants for use with HiPi::Control::LCD::HTBackPackV2

    HTV2_CMD_PRINT 
    HTV2_CMD_SET_CURSOR_POS
    HTV2_CMD_CLEAR_LINE 
    HTV2_CMD_CLEAR_DISPLAY
    HTV2_CMD_LCD_TYPE
    HTV2_CMD_HD44780_CMD
    HTV2_CMD_BACKLIGHT
    HTV2_CMD_WRITE_CHAR 
    HTV2_CMD_I2C_ADDRESS 
    HTV2_CMD_BAUD_RATE
    HTV2_CMD_CUSTOM_CHAR

=head2 :htv2baud

Constants for use with HiPi::Control::LCD::HTBackPackV2

    HTV2_BAUD_2400 
    HTV2_BAUD_4800
    HTV2_BAUD_9600
    HTV2_BAUD_14400
    HTV2_BAUD_19200
    HTV2_BAUD_28800
    HTV2_BAUD_57600 
    HTV2_BAUD_115200


=head1 LICENSE

This work is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 3 of the License, or any later 
version.

=head2 License Note

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
require Exporter;
use base qw( Exporter );

our $VERSION = '0.02';

our @_rpi_const;

if( HiPi::cpuinfo::get_piboard_rev() == 1 ) {
    require HiPi::Constant::BoardRev1;
} else {
    require HiPi::Constant::BoardRev2;
}

package HiPi::Constant;

our @EXPORT = ();
our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

#-------------------------------------------
# Constants to convert Raspberry Pi 
# PAD Pin numbers to BCM pin ids.
# our @_rpi_const is populated in BoardRevX
# sub-module
#-------------------------------------------

push @EXPORT_OK, @_rpi_const;
$EXPORT_TAGS{raspberry} = \@_rpi_const;

#-------------------------------------------
# Pin mode constants
#-------------------------------------------

use constant {
    PIN_MODE_OUTPUT => 1,
    PIN_MODE_INPUT  => 0,
};

{
    my @const = qw(
        PIN_MODE_OUTPUT PIN_MODE_INPUT
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{pinmode}  = \@const;
}

#-------------------------------------------
# Constants to convert UART to Raspberry
# Pi PAD Pin numbers
#-------------------------------------------

use constant {
    UART0_TXD      => 8,
    UART0_RXD      => 10,
    UART0_RTS      => 11,
    UART1_TXD      => 8,
    UART1_RXD      => 10,
    UART1_RTS      => 11,
};

{
    my @const = qw(
        UART0_TXD UART0_RXD UART0_RTS
        UART1_TXD UART1_RXD UART1_RTS
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{serial}  = \@const;
}

#-------------------------------------------
# Constants to convert SPI to Raspberry
# Pi PAD Pin numbers
#-------------------------------------------

use constant {
    SPI0_MOSI       => 19,
    SPI0_MISO       => 21,
    SPI0_CLK        => 23,
    SPI0_SCLK       => 23,
    SPI0_CEO_N      => 24,
    SPI0_CE1_N      => 26,
};

{
    my @const = qw(
        SPI0_MOSI SPI0_MISO SPI0_CLK SPI0_SCLK SPI0_CE0_N SPI0_CE1_N
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{spi}  = \@const;
}

#-------------------------------------------
# Constants to convert I2C to Raspberry
# Pi PAD Pin numbers
#-------------------------------------------

use constant {
    I2C0_SDA	       => 3,
    I2C0_SCL	       => 5,
};

{
    my @const = qw(
        I2C0_SDA I2C0_SCL
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{i2c}  = \@const;
}

#-------------------------------------------
# Constants to convert wiringPi pin numbers
# to Raspberry Pi PAD Pin numbers
#-------------------------------------------

use constant {
    # pad 1
    WPI_PIN_0  => 11,
    WPI_PIN_1  => 12,
    WPI_PIN_2  => 13,
    WPI_PIN_3  => 15,
    WPI_PIN_4  => 16,
    WPI_PIN_5  => 18,
    WPI_PIN_6  => 22,
    WPI_PIN_7  => 7,
    WPI_PIN_8  => 3,
    WPI_PIN_9  => 5,
    WPI_PIN_10  => 24,
    WPI_PIN_11  => 26,
    WPI_PIN_12  => 19,
    WPI_PIN_13  => 21,
    WPI_PIN_14  => 23,
    WPI_PIN_15  => 8,
    WPI_PIN_16  => 10,
    # pad 5
    WPI_PIN_17  => 3,
    WPI_PIN_18  => 4,
    WPI_PIN_19  => 5,
    WPI_PIN_20  => 6,
    
    WPI_NUM_PINS	=> 17,
    
    WPI_MODE_PINS	=>  0,
    WPI_MODE_GPIO       =>  1,
    WPI_MODE_GPIO_SYS   =>  2,
    WPI_MODE_PIFACE     =>  3,

    WPI_INPUT           =>  0,
    WPI_OUTPUT          =>  1,
    WPI_PWM_OUTPUT      =>  2,

    WPI_LOW             =>  0,
    WPI_HIGH            =>  1,

    WPI_PUD_OFF         =>  0,
    WPI_PUD_DOWN        =>  1,
    WPI_PUD_UP          =>  2,

    WPI_PWM_MODE_MS     =>  0,
    WPI_PWM_MODE_BAL    =>  1,
    
    WPI_NES_RIGHT	=> 0x01,
    WPI_NES_LEFT	=> 0x02,
    WPI_NES_DOWN	=> 0x04,
    WPI_NES_UP		=> 0x08,
    WPI_NES_START	=> 0x10,
    WPI_NES_SELECT	=> 0x20,
    WPI_NES_B		=> 0x40,
    WPI_NES_A		=> 0x80,
};

{
    my @const = qw(
        WPI_PIN_0  WPI_PIN_1  WPI_PIN_2  WPI_PIN_3  WPI_PIN_4
        WPI_PIN_5  WPI_PIN_6  WPI_PIN_7  WPI_PIN_8  WPI_PIN_9
        WPI_PIN_10 WPI_PIN_11 WPI_PIN_12 WPI_PIN_13 WPI_PIN_14
        WPI_PIN_15 WPI_PIN_16
        WPI_PIN_17 WPI_PIN_18 WPI_PIN_19 WPI_PIN_20
        WPI_NUM_PINS WPI_MODE_PINS WPI_MODE_GPIO WPI_MODE_GPIO_SYS
        WPI_MODE_PIFACE WPI_INPUT WPI_OUTPUT WPI_PWM_OUTPUT WPI_LOW
        WPI_HIGH WPI_PUD_OFF WPI_PUD_DOWN WPI_PUD_UP WPI_PWM_MODE_MS
        WPI_PWM_MODE_BAL
        WPI_NES_RIGHT WPI_NES_LEFT WPI_NES_DOWN WPI_NES_UP
        WPI_NES_START WPI_NES_SELECT WPI_NES_B WPI_NES_A
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{wiring}  = \@const;
}

#-------------------------------------------
# Constants to convert BCM pin ids
# to Raspberry Pi PAD Pin numbers
#-------------------------------------------

use constant {
    # PAD1 Rev 1
    BCM_0  => 3,
    BCM_1  => 5,
    BCM_4  => 7,
    BCM_7  => 26,
    BCM_8  => 24,
    BCM_9  => 21,
    BCM_10  => 19,
    BCM_11  => 23,
    BCM_14  => 8,
    BCM_15  => 10,
    BCM_17  => 11,
    BCM_18  => 12,
    BCM_21  => 13,
    BCM_22  => 15,
    BCM_23  => 16,
    BCM_24  => 18,
    BCM_25  => 22,
    # PAD1 Rev 2 changes
    BCM_2  => 3,
    BCM_3  => 5,
    BCM_27  => 13,
    # PAD5
    BCM_28  => 3,
    BCM_29  => 4,
    BCM_30  => 5,
    BCM_31  => 6,
};

{
    my @const = qw(
        BCM_0 BCM_1 BCM_4 BCM_7 BCM_8
        BCM_9 BCM_10 BCM_11 BCM_14 BCM_15
        BCM_17 BCM_18 BCM_21 BCM_22 BCM_23
        BCM_24 BCM_25 BCM_2 BCM_3 BCM_27
        BCM_28 BCM_29 BCM_30 BCM_31
    );

    push @EXPORT_OK, @const;
    $EXPORT_TAGS{bcm2835} = \@const;
}

#-------------------------------------------
# MCP23017
#------------------------------------------

use constant {
    MCP23017_A0     => 0x1000,
    MCP23017_A1     => 0x1001,
    MCP23017_A2     => 0x1002,
    MCP23017_A3     => 0x1003,
    MCP23017_A4     => 0x1004,
    MCP23017_A5     => 0x1005,
    MCP23017_A6     => 0x1006,
    MCP23017_A7     => 0x1007,
    MCP23017_B0     => 0x1010,
    MCP23017_B1     => 0x1011,
    MCP23017_B2     => 0x1012,
    MCP23017_B3     => 0x1013,
    MCP23017_B4     => 0x1014,
    MCP23017_B5     => 0x1015,
    MCP23017_B6     => 0x1016,
    MCP23017_B7     => 0x1017,
    
    MCP23017_BANK   => 7,
    MCP23017_MIRROR => 6,
    MCP23017_SEQOP  => 5,
    MCP23017_DISSLW => 4,
    MCP23017_HAEN   => 3,
    MCP23017_ODR    => 2,
    MCP23017_INTPOL => 1,

};

{
    my @const = qw(
        MCP23017_A0 MCP23017_A1 MCP23017_A2 MCP23017_A3 
        MCP23017_A4 MCP23017_A5 MCP23017_A6 MCP23017_A7 
        MCP23017_B0 MCP23017_B1 MCP23017_B2 MCP23017_B3 
        MCP23017_B4 MCP23017_B5 MCP23017_B6 MCP23017_B7
        MCP23017_BANK MCP23017_MIRROR MCP23017_SEQOP
        MCP23017_DISSLW MCP23017_HAEN MCP23017_ODR
        MCP23017_INTPOL
    );
    push @EXPORT_OK, @const;
    $EXPORT_TAGS{mcp23017} = \@const;
}


#--------------------------------------------------
# HobbyTronics LCD Backpack
#--------------------------------------------------

use constant {
    HTV2_CMD_PRINT          => 1,
    HTV2_CMD_SET_CURSOR_POS => 2,
    HTV2_CMD_CLEAR_LINE     => 3,
    HTV2_CMD_CLEAR_DISPLAY  => 4,
    HTV2_CMD_LCD_TYPE       => 5,
    HTV2_CMD_HD44780_CMD    => 6,
    HTV2_CMD_BACKLIGHT      => 7,
    HTV2_CMD_WRITE_CHAR     => 10,
    HTV2_CMD_I2C_ADDRESS    => 32,
    HTV2_CMD_BAUD_RATE      => 33,
    HTV2_CMD_CUSTOM_CHAR    => 64,
};

{
    my @const = qw(
        HTV2_CMD_PRINT 
        HTV2_CMD_SET_CURSOR_POS
        HTV2_CMD_CLEAR_LINE
        HTV2_CMD_CLEAR_DISPLAY
        HTV2_CMD_LCD_TYPE
        HTV2_CMD_HD44780_CMD 
        HTV2_CMD_BACKLIGHT 
        HTV2_CMD_WRITE_CHAR
        HTV2_CMD_I2C_ADDRESS
        HTV2_CMD_BAUD_RATE
        HTV2_CMD_CUSTOM_CHAR
    );
    
    push( @EXPORT_OK, @const );
    $EXPORT_TAGS{htv2cmd} = \@const;
}

use constant {
    HTV2_BAUD_2400    => 0,
    HTV2_BAUD_4800    => 1,
    HTV2_BAUD_9600    => 2,
    HTV2_BAUD_14400   => 3,
    HTV2_BAUD_19200   => 4,
    HTV2_BAUD_28800   => 5,
    HTV2_BAUD_57600   => 6,
    HTV2_BAUD_115200  => 7,
};

{
    my @const = qw(
        HTV2_BAUD_2400
        HTV2_BAUD_4800 
        HTV2_BAUD_9600 
        HTV2_BAUD_14400
        HTV2_BAUD_19200
        HTV2_BAUD_28800
        HTV2_BAUD_57600
        HTV2_BAUD_115200
    );
    push( @EXPORT_OK, @const );
    $EXPORT_TAGS{htv2baud} = \@const;
}


1;
