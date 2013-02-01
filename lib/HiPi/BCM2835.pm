#########################################################################################
# Package       HiPi::BCM2835
# Description:  Wrapper for bcm2835 C library
# Created       Fri Nov 23 13:55:49 2012
# SVN Id        $Id: BCM2835.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::BCM2835;

#########################################################################################

=head1 NAME

HiPi::BCM2835 

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::BCM2835 qw( :registers :memory :function
                          :pud :pad :pins :spi :pwm);

    HiPi::BCM2835::bcm2835_init();
    ...
    ...
    HiPi::BCM2835::bcm2835_close();
    
=head1 DESCRIPTION

This module is a thin wrapper around the excellent BCM2835 C library by
Mike McCauley, C<<mikem@open.com.au>>

The original library and documentation  are available at:

L<http://www.open.com.au/mikem/bcm2835/>

Mike also provides his own wrapper - the CPAN module Device::BCM2835

Normally this module is not used directly in end user code. The modules
HiPi::GPIO, HiPi::GPIO::PAD1 and HiPi::GPIO::PAD5 are intended for
direct end user use.

=head1 EXPORTED CONSTANT TAGS

=head2 :registers

    BCM2835_PERI_BASE
    BCM2835_GPIO_PADS
    BCM2835_CLOCK_BASE
    BCM2835_GPIO_BASE
    BCM2835_SPI0_BASE
    BCM2835_GPIO_PWM

=head2 :memory

    BCM2835_PAGE_SIZE
    BCM2835_BLOCK_SIZE

=head2 :function

    BCM2835_GPFSEL0
    BCM2835_GPFSEL1
    BCM2835_GPFSEL2
    BCM2835_GPFSEL3
    BCM2835_GPFSEL4
    BCM2835_GPFSEL5
    BCM2835_GPSET0
    BCM2835_GPSET1
    BCM2835_GPCLR0
    BCM2835_GPCLR1
    BCM2835_GPLEV0
    BCM2835_GPLEV1
    BCM2835_GPEDS0
    BCM2835_GPEDS1
    BCM2835_GPREN0
    BCM2835_GPREN1
    BCM2835_GPFEN0
    BCM2835_GPFEN1
    BCM2835_GPHEN0
    BCM2835_GPHEN1
    BCM2835_GPLEN0
    BCM2835_GPLEN1
    BCM2835_GPAREN0
    BCM2835_GPAREN1
    BCM2835_GPAFEN0
    BCM2835_GPAFEN1
    BCM2835_GPPUD
    BCM2835_GPPUDCLK0
    BCM2835_GPPUDCLK1
    BCM2835_GPIO_FSEL_INPT
    BCM2835_GPIO_FSEL_OUTP
    BCM2835_GPIO_FSEL_ALT0
    BCM2835_GPIO_FSEL_ALT1
    BCM2835_GPIO_FSEL_ALT2
    BCM2835_GPIO_FSEL_ALT3
    BCM2835_GPIO_FSEL_ALT4
    BCM2835_GPIO_FSEL_ALT5
    BCM2835_GPIO_FSEL_MASK

=head2 :pud

    BCM2835_GPIO_PUD_OFF
    BCM2835_GPIO_PUD_DOWN
    BCM2835_GPIO_PUD_UP

=head2 :pads

    BCM2835_PADS_GPIO_0_27  
    BCM2835_PADS_GPIO_28_45
    BCM2835_PADS_GPIO_46_53  
    BCM2835_PAD_PASSWRD   
    BCM2835_PAD_SLEW_RATE_UNLIMITED
    BCM2835_PAD_HYSTERESIS_ENABLED 
    BCM2835_PAD_DRIVE_2mA 
    BCM2835_PAD_DRIVE_4mA 
    BCM2835_PAD_DRIVE_6mA 
    BCM2835_PAD_DRIVE_8mA 
    BCM2835_PAD_DRIVE_10mA 
    BCM2835_PAD_DRIVE_12mA 
    BCM2835_PAD_DRIVE_14mA 
    BCM2835_PAD_DRIVE_16mA 
    BCM2835_PAD_GROUP_GPIO_0_27 
    BCM2835_PAD_GROUP_GPIO_28_45 
    BCM2835_PAD_GROUP_GPIO_46_53 

=head2 :pins

    RPI_GPIO_P1_03  
    RPI_GPIO_P1_05
    RPI_GPIO_P1_07
    RPI_GPIO_P1_08
    RPI_GPIO_P1_10
    RPI_GPIO_P1_11 
    RPI_GPIO_P1_12  
    RPI_GPIO_P1_13  
    RPI_GPIO_P1_15   
    RPI_GPIO_P1_16 
    RPI_GPIO_P1_18 
    RPI_GPIO_P1_19 
    RPI_GPIO_P1_21 
    RPI_GPIO_P1_22 
    RPI_GPIO_P1_23  
    RPI_GPIO_P1_24 
    RPI_GPIO_P1_26      
    RPI_V2_GPIO_P1_03  
    RPI_V2_GPIO_P1_05  
    RPI_V2_GPIO_P1_07  
    RPI_V2_GPIO_P1_08 
    RPI_V2_GPIO_P1_10
    RPI_V2_GPIO_P1_11 
    RPI_V2_GPIO_P1_12 
    RPI_V2_GPIO_P1_13 
    RPI_V2_GPIO_P1_15 
    RPI_V2_GPIO_P1_16 
    RPI_V2_GPIO_P1_18 
    RPI_V2_GPIO_P1_19 
    RPI_V2_GPIO_P1_21 
    RPI_V2_GPIO_P1_22 
    RPI_V2_GPIO_P1_23 
    RPI_V2_GPIO_P1_24 
    RPI_V2_GPIO_P1_26
    RPI_V2_GPIO_P5_03
    RPI_V2_GPIO_P5_04
    RPI_V2_GPIO_P5_05
    RPI_V2_GPIO_P5_06   

=head2 :spi

    BCM2835_SPI0_CS  
    BCM2835_SPI0_FIFO
    BCM2835_SPI0_CLK 
    BCM2835_SPI0_DLEN  
    BCM2835_SPI0_LTOH  
    BCM2835_SPI0_DC  
    BCM2835_SPI0_CS_LEN_LONG
    BCM2835_SPI0_CS_DMA_LEN
    BCM2835_SPI0_CS_CSPOL2 
    BCM2835_SPI0_CS_CSPOL1
    BCM2835_SPI0_CS_CSPOL0 
    BCM2835_SPI0_CS_RXF  
    BCM2835_SPI0_CS_RXR
    BCM2835_SPI0_CS_TXD 
    BCM2835_SPI0_CS_RXD 
    BCM2835_SPI0_CS_DONE 
    BCM2835_SPI0_CS_TE_EN 
    BCM2835_SPI0_CS_LMONO 
    BCM2835_SPI0_CS_LEN
    BCM2835_SPI0_CS_REN 
    BCM2835_SPI0_CS_ADCS 
    BCM2835_SPI0_CS_INTR 
    BCM2835_SPI0_CS_INTD
    BCM2835_SPI0_CS_DMAEN 
    BCM2835_SPI0_CS_TA 
    BCM2835_SPI0_CS_CSPOL 
    BCM2835_SPI0_CS_CLEAR 
    BCM2835_SPI0_CS_CLEAR_RX 
    BCM2835_SPI0_CS_CLEAR_TX
    BCM2835_SPI0_CS_CPOL 
    BCM2835_SPI0_CS_CPHA 
    BCM2835_SPI0_CS_CS 
    BCM2835_SPI_BIT_ORDER_LSBFIRST
    BCM2835_SPI_BIT_ORDER_MSBFIRST
    BCM2835_SPI_MODE0 
    BCM2835_SPI_MODE1
    BCM2835_SPI_MODE2
    BCM2835_SPI_MODE3 
    BCM2835_SPI_CS0 
    BCM2835_SPI_CS1 
    BCM2835_SPI_CS2 
    BCM2835_SPI_CS_NONE 
    BCM2835_SPI_CLOCK_DIVIDER_65536
    BCM2835_SPI_CLOCK_DIVIDER_32768 
    BCM2835_SPI_CLOCK_DIVIDER_16384
    BCM2835_SPI_CLOCK_DIVIDER_8192
    BCM2835_SPI_CLOCK_DIVIDER_4096 
    BCM2835_SPI_CLOCK_DIVIDER_2048 
    BCM2835_SPI_CLOCK_DIVIDER_1024
    BCM2835_SPI_CLOCK_DIVIDER_512 
    BCM2835_SPI_CLOCK_DIVIDER_256
    BCM2835_SPI_CLOCK_DIVIDER_128 
    BCM2835_SPI_CLOCK_DIVIDER_64
    BCM2835_SPI_CLOCK_DIVIDER_32 
    BCM2835_SPI_CLOCK_DIVIDER_16
    BCM2835_SPI_CLOCK_DIVIDER_8
    BCM2835_SPI_CLOCK_DIVIDER_4
    BCM2835_SPI_CLOCK_DIVIDER_2
    BCM2835_SPI_CLOCK_DIVIDER_1

=head2 :pwm

    BCM2835_PWM_CONTROL
    BCM2835_PWM_STATUS
    BCM2835_PWM0_RANGE 
    BCM2835_PWM0_DATA
    BCM2835_PWM1_RANGE 
    BCM2835_PWM1_DATA 
    BCM2835_PWMCLK_CNTL
    BCM2835_PWMCLK_DIV 
    BCM2835_PWM1_MS_MODE
    BCM2835_PWM1_USEFIFO
    BCM2835_PWM1_REVPOLAR
    BCM2835_PWM1_OFFSTATE
    BCM2835_PWM1_REPEATFF
    BCM2835_PWM1_SERIAL
    BCM2835_PWM1_ENABLE
    BCM2835_PWM0_MS_MODE
    BCM2835_PWM0_USEFIFO
    BCM2835_PWM0_REVPOLAR
    BCM2835_PWM0_OFFSTATE
    BCM2835_PWM0_REPEATFF
    BCM2835_PWM0_SERIAL
    BCM2835_PWM0_ENABLE

=head1 METHODS

The methods listed at L<http://www.open.com.au/mikem/bcm2835/modules.html>
are wrapped.

An example to set Raspberry Pi GPIO Pin 11 mode to output and 'on', then
reset RPi pins 3 & 5 for standard I2C use (alt function 0);

    use HiPi::BCM2835 qw( :pins :function );
    HiPi::BCM2835::bcm2835_gpio_fsel( RPI_V2_GPIO_P1_11 , BCM2835_GPIO_FSEL_OUTP);
    HiPi::BCM2835::bcm2835_gpio_set( RPI_V2_GPIO_P1_11);
    
    HiPi::BCM2835::bcm2835_gpio_fsel( RPI_V2_GPIO_P1_03 , BCM2835_GPIO_FSEL_ALT0);
    HiPi::BCM2835::bcm2835_gpio_fsel( RPI_V2_GPIO_P1_05 , BCM2835_GPIO_FSEL_ALT0);

Note that the HiPi::BCM2835 functions expect pin numbers to be the Broadcomm
BCM 2835 GPIO pin numbers - which are different to the Raspberry Pi Pad 1 pin
header layout. Use the constants RPI_V2_GPIO_P1_xx to get BCM GPIO numbers for
Raspberry Pi GPIO header pin numbers.

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

use strict;
use warnings;
use Exporter;
use base qw( Exporter );
use XSLoader;

our $VERSION = '0.01';

unless($ENV{DEV_NONE_RASPBERRY_PLATFORM}) {
    # on real Raspberry Pi
    XSLoader::load('HiPi::BCM2835', $VERSION);
}

# Constants for libbcm2835

our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

sub _register_exported_constants {
    my( $tag, @constants ) = @_;
    $EXPORT_TAGS{$tag} = \@constants;
    push( @EXPORT_OK, @constants);
}

# define HIGH / LOW at HiPi level as RPI_HIGH / RPI_LOW

#-------------------------------------------------------
# Physical addresses for various peripheral regiser sets
#-------------------------------------------------------

use constant {
    BCM2835_PERI_BASE   => 0x20000000,
    BCM2835_GPIO_PADS   => 0x20000000 + 0x100000,
    BCM2835_CLOCK_BASE  => 0x20000000 + 0x101000,
    BCM2835_GPIO_BASE   => 0x20000000 + 0x200000,
    BCM2835_SPI0_BASE   => 0x20000000 + 0x204000,
    BCM2835_GPIO_PWM    => 0x20000000 + 0x20C000,
};

_register_exported_constants( qw(
    registers
    BCM2835_PERI_BASE
    BCM2835_GPIO_PADS
    BCM2835_CLOCK_BASE
    BCM2835_GPIO_BASE
    BCM2835_SPI0_BASE
    BCM2835_GPIO_PWM
    ) );

#-------------------------------------------------------
# Memory
#-------------------------------------------------------

use constant {
    BCM2835_PAGE_SIZE  => 4*1024,
    BCM2835_BLOCK_SIZE => 4*1024,
};

_register_exported_constants( qw(
    memory
    BCM2835_PAGE_SIZE
    BCM2835_BLOCK_SIZE
    ) );

#-----------------------------------------------------
# Defines for GPIO
# The BCM2835 has 54 GPIO pins.
#      BCM2835 data sheet, Page 90 onwards.
# GPIO register offsets from BCM2835_GPIO_BASE. Offsets into the GPIO Peripheral block in bytes per 6.1 Register View
#-----------------------------------------------------

use constant {
    BCM2835_GPFSEL0    => 0x0000, # GPIO Function Select 0
    BCM2835_GPFSEL1    => 0x0004, # GPIO Function Select 1
    BCM2835_GPFSEL2    => 0x0008, # GPIO Function Select 2
    BCM2835_GPFSEL3    => 0x000c, # GPIO Function Select 3
    BCM2835_GPFSEL4    => 0x0010, # GPIO Function Select 4
    BCM2835_GPFSEL5    => 0x0014, # GPIO Function Select 5
    BCM2835_GPSET0     => 0x001c, # GPIO Pin Output Set 0
    BCM2835_GPSET1     => 0x0020, # GPIO Pin Output Set 1
    BCM2835_GPCLR0     => 0x0028, # GPIO Pin Output Clear 0
    BCM2835_GPCLR1     => 0x002c, # GPIO Pin Output Clear 1
    BCM2835_GPLEV0     => 0x0034, # GPIO Pin Level 0
    BCM2835_GPLEV1     => 0x0038, # GPIO Pin Level 1
    BCM2835_GPEDS0     => 0x0040, # GPIO Pin Event Detect Status 0
    BCM2835_GPEDS1     => 0x0044, # GPIO Pin Event Detect Status 1
    BCM2835_GPREN0     => 0x004c, # GPIO Pin Rising Edge Detect Enable 0
    BCM2835_GPREN1     => 0x0050, # GPIO Pin Rising Edge Detect Enable 1
    BCM2835_GPFEN0     => 0x0048, # GPIO Pin Falling Edge Detect Enable 0
    BCM2835_GPFEN1     => 0x005c, # GPIO Pin Falling Edge Detect Enable 1
    BCM2835_GPHEN0     => 0x0064, # GPIO Pin High Detect Enable 0
    BCM2835_GPHEN1     => 0x0068, # GPIO Pin High Detect Enable 1
    BCM2835_GPLEN0     => 0x0070, # GPIO Pin Low Detect Enable 0
    BCM2835_GPLEN1     => 0x0074, # GPIO Pin Low Detect Enable 1
    BCM2835_GPAREN0    => 0x007c, # GPIO Pin Async. Rising Edge Detect 0
    BCM2835_GPAREN1    => 0x0080, # GPIO Pin Async. Rising Edge Detect 1
    BCM2835_GPAFEN0    => 0x0088, # GPIO Pin Async. Falling Edge Detect 0
    BCM2835_GPAFEN1    => 0x008c, # GPIO Pin Async. Falling Edge Detect 1
    BCM2835_GPPUD      => 0x0094, # GPIO Pin Pull-up/down Enable
    BCM2835_GPPUDCLK0  => 0x0098, # GPIO Pin Pull-up/down Enable Clock 0
    BCM2835_GPPUDCLK1  => 0x009c, # GPIO Pin Pull-up/down Enable Clock 1
    #-------------------------------------------------------
    # Port function select modes for bcm2845_gpio_fsel()
    #-------------------------------------------------------
    BCM2835_GPIO_FSEL_INPT  => 0, # Input
    BCM2835_GPIO_FSEL_OUTP  => 1, # Output
    BCM2835_GPIO_FSEL_ALT0  => 4, # Alternate function 0
    BCM2835_GPIO_FSEL_ALT1  => 5, # Alternate function 1
    BCM2835_GPIO_FSEL_ALT2  => 6, # Alternate function 2
    BCM2835_GPIO_FSEL_ALT3  => 7, # Alternate function 3
    BCM2835_GPIO_FSEL_ALT4  => 3, # Alternate function 4
    BCM2835_GPIO_FSEL_ALT5  => 2, # Alternate function 5
    BCM2835_GPIO_FSEL_MASK  => 7  # Function select bits mask
};

_register_exported_constants( qw(
    function
    BCM2835_GPFSEL0
    BCM2835_GPFSEL1
    BCM2835_GPFSEL2
    BCM2835_GPFSEL3
    BCM2835_GPFSEL4
    BCM2835_GPFSEL5
    BCM2835_GPSET0
    BCM2835_GPSET1
    BCM2835_GPCLR0
    BCM2835_GPCLR1
    BCM2835_GPLEV0
    BCM2835_GPLEV1
    BCM2835_GPEDS0
    BCM2835_GPEDS1
    BCM2835_GPREN0
    BCM2835_GPREN1
    BCM2835_GPFEN0
    BCM2835_GPFEN1
    BCM2835_GPHEN0
    BCM2835_GPHEN1
    BCM2835_GPLEN0
    BCM2835_GPLEN1
    BCM2835_GPAREN0
    BCM2835_GPAREN1
    BCM2835_GPAFEN0
    BCM2835_GPAFEN1
    BCM2835_GPPUD
    BCM2835_GPPUDCLK0
    BCM2835_GPPUDCLK1
    
    BCM2835_GPIO_FSEL_INPT
    BCM2835_GPIO_FSEL_OUTP
    BCM2835_GPIO_FSEL_ALT0
    BCM2835_GPIO_FSEL_ALT1
    BCM2835_GPIO_FSEL_ALT2
    BCM2835_GPIO_FSEL_ALT3
    BCM2835_GPIO_FSEL_ALT4
    BCM2835_GPIO_FSEL_ALT5
    BCM2835_GPIO_FSEL_MASK
    ) );

#----------------------------------------------------------
# Pullup/Pulldown defines for bcm2845_gpio_pud()
#----------------------------------------------------------

use constant {
    BCM2835_GPIO_PUD_OFF  => 0,  # < Off ? disable pull-up/down
    BCM2835_GPIO_PUD_DOWN => 1,  # < Enable Pull Down control
    BCM2835_GPIO_PUD_UP   => 2   # < Enable Pull Up control
};

_register_exported_constants( qw(
    pud
    BCM2835_GPIO_PUD_OFF
    BCM2835_GPIO_PUD_DOWN
    BCM2835_GPIO_PUD_UP
    ) );

#----------------------------------------------------------
# Pad control register offsets from BCM2835_GPIO_PADS,
# control masks and groups
#----------------------------------------------------------

use constant {
    BCM2835_PADS_GPIO_0_27          => 0x002c,        #< Pad control register for pads 0 to 27
    BCM2835_PADS_GPIO_28_45         => 0x0030,        #< Pad control register for pads 28 to 45
    BCM2835_PADS_GPIO_46_53         => 0x0034,        #< Pad control register for pads 46 to 53
    BCM2835_PAD_PASSWRD             => (0x5A << 24),  #< Password to enable setting pad mask
    BCM2835_PAD_SLEW_RATE_UNLIMITED => 0x10,          #< Slew rate unlimited
    BCM2835_PAD_HYSTERESIS_ENABLED  => 0x08,          #< Hysteresis enabled
    BCM2835_PAD_DRIVE_2mA           => 0x00,          #< 2mA drive current
    BCM2835_PAD_DRIVE_4mA           => 0x01,          #< 4mA drive current
    BCM2835_PAD_DRIVE_6mA           => 0x02,          #< 6mA drive current
    BCM2835_PAD_DRIVE_8mA           => 0x03,          #< 8mA drive current
    BCM2835_PAD_DRIVE_10mA          => 0x04,          #< 10mA drive current
    BCM2835_PAD_DRIVE_12mA          => 0x05,          #< 12mA drive current
    BCM2835_PAD_DRIVE_14mA          => 0x06,          #< 14mA drive current
    BCM2835_PAD_DRIVE_16mA          => 0x07,          #< 16mA drive current
    BCM2835_PAD_GROUP_GPIO_0_27     => 0,             #< Pad group for GPIO pads 0 to 27
    BCM2835_PAD_GROUP_GPIO_28_45    => 1,             #< Pad group for GPIO pads 28 to 45
    BCM2835_PAD_GROUP_GPIO_46_53    => 2,             #< Pad group for GPIO pads 46 to 53

};

_register_exported_constants( qw(
    pads
    BCM2835_PADS_GPIO_0_27  
    BCM2835_PADS_GPIO_28_45
    BCM2835_PADS_GPIO_46_53  
    BCM2835_PAD_PASSWRD   
    BCM2835_PAD_SLEW_RATE_UNLIMITED
    BCM2835_PAD_HYSTERESIS_ENABLED 
    BCM2835_PAD_DRIVE_2mA 
    BCM2835_PAD_DRIVE_4mA 
    BCM2835_PAD_DRIVE_6mA 
    BCM2835_PAD_DRIVE_8mA 
    BCM2835_PAD_DRIVE_10mA 
    BCM2835_PAD_DRIVE_12mA 
    BCM2835_PAD_DRIVE_14mA 
    BCM2835_PAD_DRIVE_16mA 
    BCM2835_PAD_GROUP_GPIO_0_27 
    BCM2835_PAD_GROUP_GPIO_28_45 
    BCM2835_PAD_GROUP_GPIO_46_53 
    ) );

#------------------------------------------------------------------------------------------------
# Here we define Raspberry Pin GPIO pins on P1 in terms of the underlying BCM GPIO pin numbers.
# These can be passed as a pin number to any function requiring a pin.
# Not all pins on the RPi 26 bin IDE plug are connected to GPIO pins
# and some can adopt an alternate function.
# RPi version 2 has some slightly different pinouts, and these are values RPI_V2_*.
# At bootup, pins 8 and 10 are set to UART0_TXD, UART0_RXD (ie the alt0 function) respectively
# When SPI0 is in use (ie after bcm2835_spi_begin()), pins 19, 21, 23, 24, 26 are dedicated to SPI
# and cant be controlled independently
#-------------------------------------------------------------------------------------------------

use constant {
    RPI_GPIO_P1_03        =>  0,  #  Version 1, Pin P1-03
    RPI_GPIO_P1_05        =>  1,  #  Version 1, Pin P1-05
    RPI_GPIO_P1_07        =>  4,  #  Version 1, Pin P1-07
    RPI_GPIO_P1_08        => 14,  #  Version 1, Pin P1-08, defaults to alt function 0 UART0_TXD
    RPI_GPIO_P1_10        => 15,  #  Version 1, Pin P1-10, defaults to alt function 0 UART0_RXD
    RPI_GPIO_P1_11        => 17,  #  Version 1, Pin P1-11
    RPI_GPIO_P1_12        => 18,  #  Version 1, Pin P1-12
    RPI_GPIO_P1_13        => 21,  #  Version 1, Pin P1-13
    RPI_GPIO_P1_15        => 22,  #  Version 1, Pin P1-15
    RPI_GPIO_P1_16        => 23,  #  Version 1, Pin P1-16
    RPI_GPIO_P1_18        => 24,  #  Version 1, Pin P1-18
    RPI_GPIO_P1_19        => 10,  #  Version 1, Pin P1-19, MOSI when SPI0 in use
    RPI_GPIO_P1_21        =>  9,  #  Version 1, Pin P1-21, MISO when SPI0 in use
    RPI_GPIO_P1_22        => 25,  #  Version 1, Pin P1-22
    RPI_GPIO_P1_23        => 11,  #  Version 1, Pin P1-23, CLK when SPI0 in use
    RPI_GPIO_P1_24        =>  8,  #  Version 1, Pin P1-24, CE0 when SPI0 in use
    RPI_GPIO_P1_26        =>  7,  #  Version 1, Pin P1-26, CE1 when SPI0 in use

    RPI_V2_GPIO_P1_03     =>  2,  #  Version 2, Pin P1-03
    RPI_V2_GPIO_P1_05     =>  3,  #  Version 2, Pin P1-05
    RPI_V2_GPIO_P1_07     =>  4,  #  Version 2, Pin P1-07
    RPI_V2_GPIO_P1_08     => 14,  #  Version 2, Pin P1-08, defaults to alt function 0 UART0_TXD
    RPI_V2_GPIO_P1_10     => 15,  #  Version 2, Pin P1-10, defaults to alt function 0 UART0_RXD
    RPI_V2_GPIO_P1_11     => 17,  #  Version 2, Pin P1-11
    RPI_V2_GPIO_P1_12     => 18,  #  Version 2, Pin P1-12
    RPI_V2_GPIO_P1_13     => 27,  #  Version 2, Pin P1-13
    RPI_V2_GPIO_P1_15     => 22,  #  Version 2, Pin P1-15
    RPI_V2_GPIO_P1_16     => 23,  #  Version 2, Pin P1-16
    RPI_V2_GPIO_P1_18     => 24,  #  Version 2, Pin P1-18
    RPI_V2_GPIO_P1_19     => 10,  #  Version 2, Pin P1-19, MOSI when SPI0 in use
    RPI_V2_GPIO_P1_21     =>  9,  #  Version 2, Pin P1-21, MISO when SPI0 in use
    RPI_V2_GPIO_P1_22     => 25,  #  Version 2, Pin P1-22
    RPI_V2_GPIO_P1_23     => 11,  #  Version 2, Pin P1-23, CLK when SPI0 in use
    RPI_V2_GPIO_P1_24     =>  8,  #  Version 2, Pin P1-24, CE0 when SPI0 in use
    RPI_V2_GPIO_P1_26     =>  7,  #  Version 2, Pin P1-26, CE1 when SPI0 in use
    
    RPI_V2_GPIO_P5_03     => 28,  #  Version 2, Pin P5-03
    RPI_V2_GPIO_P5_04     => 29,  #  Version 2, Pin P5-04
    RPI_V2_GPIO_P5_05     => 30,  #  Version 2, Pin P5-05
    RPI_V2_GPIO_P5_06     => 31,  #  Version 2, Pin P5-06
    
};

_register_exported_constants( qw(
    pins
    RPI_GPIO_P1_03  
    RPI_GPIO_P1_05
    RPI_GPIO_P1_07
    RPI_GPIO_P1_08
    RPI_GPIO_P1_10
    RPI_GPIO_P1_11 
    RPI_GPIO_P1_12  
    RPI_GPIO_P1_13  
    RPI_GPIO_P1_15   
    RPI_GPIO_P1_16 
    RPI_GPIO_P1_18 
    RPI_GPIO_P1_19 
    RPI_GPIO_P1_21 
    RPI_GPIO_P1_22 
    RPI_GPIO_P1_23  
    RPI_GPIO_P1_24 
    RPI_GPIO_P1_26      
    RPI_V2_GPIO_P1_03  
    RPI_V2_GPIO_P1_05  
    RPI_V2_GPIO_P1_07  
    RPI_V2_GPIO_P1_08 
    RPI_V2_GPIO_P1_10
    RPI_V2_GPIO_P1_11 
    RPI_V2_GPIO_P1_12 
    RPI_V2_GPIO_P1_13 
    RPI_V2_GPIO_P1_15 
    RPI_V2_GPIO_P1_16 
    RPI_V2_GPIO_P1_18 
    RPI_V2_GPIO_P1_19 
    RPI_V2_GPIO_P1_21 
    RPI_V2_GPIO_P1_22 
    RPI_V2_GPIO_P1_23 
    RPI_V2_GPIO_P1_24 
    RPI_V2_GPIO_P1_26
    
    RPI_V2_GPIO_P5_03
    RPI_V2_GPIO_P5_04
    RPI_V2_GPIO_P5_05
    RPI_V2_GPIO_P5_06   
    ) );


#---------------------------------------------------------------------------
# Defines for SPI
#---------------------------------------------------------------------------

use constant {
    # GPIO register offsets from BCM2835_SPI0_BASE. 
    # Offsets into the SPI Peripheral block in bytes per 10.5 SPI Register Map
    BCM2835_SPI0_CS                 => 0x0000, #  SPI Master Control and Status
    BCM2835_SPI0_FIFO               => 0x0004, #  SPI Master TX and RX FIFOs
    BCM2835_SPI0_CLK                => 0x0008, #  SPI Master Clock Divider
    BCM2835_SPI0_DLEN               => 0x000c, #  SPI Master Data Length
    BCM2835_SPI0_LTOH               => 0x0010, #  SPI LOSSI mode TOH
    BCM2835_SPI0_DC                 => 0x0014, #  SPI DMA DREQ Controls

    # Register masks for SPI0_CS
    BCM2835_SPI0_CS_LEN_LONG        => 0x02000000, #  Enable Long data word in Lossi mode if DMA_LEN is set
    BCM2835_SPI0_CS_DMA_LEN         => 0x01000000, #  Enable DMA mode in Lossi mode
    BCM2835_SPI0_CS_CSPOL2          => 0x00800000, #  Chip Select 2 Polarity
    BCM2835_SPI0_CS_CSPOL1          => 0x00400000, #  Chip Select 1 Polarity
    BCM2835_SPI0_CS_CSPOL0          => 0x00200000, #  Chip Select 0 Polarity
    BCM2835_SPI0_CS_RXF             => 0x00100000, #  RXF - RX FIFO Full
    BCM2835_SPI0_CS_RXR             => 0x00080000, #  RXR RX FIFO needs Reading ( full)
    BCM2835_SPI0_CS_TXD             => 0x00040000, #  TXD TX FIFO can accept Data
    BCM2835_SPI0_CS_RXD             => 0x00020000, #  RXD RX FIFO contains Data
    BCM2835_SPI0_CS_DONE            => 0x00010000, #  Done transfer Done
    BCM2835_SPI0_CS_TE_EN           => 0x00008000, #  Unused
    BCM2835_SPI0_CS_LMONO           => 0x00004000, #  Unused
    BCM2835_SPI0_CS_LEN             => 0x00002000, #  LEN LoSSI enable
    BCM2835_SPI0_CS_REN             => 0x00001000, #  REN Read Enable
    BCM2835_SPI0_CS_ADCS            => 0x00000800, #  ADCS Automatically Deassert Chip Select
    BCM2835_SPI0_CS_INTR            => 0x00000400, #  INTR Interrupt on RXR
    BCM2835_SPI0_CS_INTD            => 0x00000200, #  INTD Interrupt on Done
    BCM2835_SPI0_CS_DMAEN           => 0x00000100, #  DMAEN DMA Enable
    BCM2835_SPI0_CS_TA              => 0x00000080, #  Transfer Active
    BCM2835_SPI0_CS_CSPOL           => 0x00000040, #  Chip Select Polarity
    BCM2835_SPI0_CS_CLEAR           => 0x00000030, #  Clear FIFO Clear RX and TX
    BCM2835_SPI0_CS_CLEAR_RX        => 0x00000020, #  Clear FIFO Clear RX 
    BCM2835_SPI0_CS_CLEAR_TX        => 0x00000010, #  Clear FIFO Clear TX 
    BCM2835_SPI0_CS_CPOL            => 0x00000008, #  Clock Polarity
    BCM2835_SPI0_CS_CPHA            => 0x00000004, #  Clock Phase
    BCM2835_SPI0_CS_CS              => 0x00000003, #  Chip Select

    # Specifies the SPI data bit ordering
    BCM2835_SPI_BIT_ORDER_LSBFIRST  => 0,  #  LSB First
    BCM2835_SPI_BIT_ORDER_MSBFIRST  => 1,   #  MSB First
    
    # Specify the SPI data mode
    BCM2835_SPI_MODE0 => 0,  #  CPOL = 0, CPHA = 0
    BCM2835_SPI_MODE1 => 1,  #  CPOL = 0, CPHA = 1
    BCM2835_SPI_MODE2 => 2,  #  CPOL = 1, CPHA = 0
    BCM2835_SPI_MODE3 => 3,  #  CPOL = 1, CPHA = 1
    
    # Specify the SPI chip select pin(s)
    BCM2835_SPI_CS0     => 0, #  Chip Select 0
    BCM2835_SPI_CS1     => 1, #  Chip Select 1
    BCM2835_SPI_CS2     => 2, #  Chip Select 2 (ie pins CS1 and CS2 are asserted)
    BCM2835_SPI_CS_NONE => 3, #  No CS, control it yourself
    
    # Specifies the divider used to generate the SPI clock from the system clock.
    # Figures below give the divider, clock period and clock frequency.
    BCM2835_SPI_CLOCK_DIVIDER_65536 => 0,       #  65536 = 256us = 4kHz
    BCM2835_SPI_CLOCK_DIVIDER_32768 => 32768,   #  32768 = 126us = 8kHz
    BCM2835_SPI_CLOCK_DIVIDER_16384 => 16384,   #  16384 = 64us = 15.625kHz
    BCM2835_SPI_CLOCK_DIVIDER_8192  => 8192,    #  8192 = 32us = 31.25kHz
    BCM2835_SPI_CLOCK_DIVIDER_4096  => 4096,    #  4096 = 16us = 62.5kHz
    BCM2835_SPI_CLOCK_DIVIDER_2048  => 2048,    #  2048 = 8us = 125kHz
    BCM2835_SPI_CLOCK_DIVIDER_1024  => 1024,    #  1024 = 4us = 250kHz
    BCM2835_SPI_CLOCK_DIVIDER_512   => 512,     #  512 = 2us = 500kHz
    BCM2835_SPI_CLOCK_DIVIDER_256   => 256,     #  256 = 1us = 1MHz
    BCM2835_SPI_CLOCK_DIVIDER_128   => 128,     #  128 = 500ns = = 2MHz
    BCM2835_SPI_CLOCK_DIVIDER_64    => 64,      #  64 = 250ns = 4MHz
    BCM2835_SPI_CLOCK_DIVIDER_32    => 32,      #  32 = 125ns = 8MHz
    BCM2835_SPI_CLOCK_DIVIDER_16    => 16,      #  16 = 50ns = 20MHz
    BCM2835_SPI_CLOCK_DIVIDER_8     => 8,       #  8 = 25ns = 40MHz
    BCM2835_SPI_CLOCK_DIVIDER_4     => 4,       #  4 = 12.5ns 80MHz
    BCM2835_SPI_CLOCK_DIVIDER_2     => 2,       #  2 = 6.25ns = 160MHz
    BCM2835_SPI_CLOCK_DIVIDER_1     => 1,       #  0 = 256us = 4kHz
    
};

_register_exported_constants( qw(
    spi
    BCM2835_SPI0_CS  
    BCM2835_SPI0_FIFO
    BCM2835_SPI0_CLK 
    BCM2835_SPI0_DLEN  
    BCM2835_SPI0_LTOH  
    BCM2835_SPI0_DC  
    BCM2835_SPI0_CS_LEN_LONG
    BCM2835_SPI0_CS_DMA_LEN
    BCM2835_SPI0_CS_CSPOL2 
    BCM2835_SPI0_CS_CSPOL1
    BCM2835_SPI0_CS_CSPOL0 
    BCM2835_SPI0_CS_RXF  
    BCM2835_SPI0_CS_RXR
    BCM2835_SPI0_CS_TXD 
    BCM2835_SPI0_CS_RXD 
    BCM2835_SPI0_CS_DONE 
    BCM2835_SPI0_CS_TE_EN 
    BCM2835_SPI0_CS_LMONO 
    BCM2835_SPI0_CS_LEN
    BCM2835_SPI0_CS_REN 
    BCM2835_SPI0_CS_ADCS 
    BCM2835_SPI0_CS_INTR 
    BCM2835_SPI0_CS_INTD
    BCM2835_SPI0_CS_DMAEN 
    BCM2835_SPI0_CS_TA 
    BCM2835_SPI0_CS_CSPOL 
    BCM2835_SPI0_CS_CLEAR 
    BCM2835_SPI0_CS_CLEAR_RX 
    BCM2835_SPI0_CS_CLEAR_TX
    BCM2835_SPI0_CS_CPOL 
    BCM2835_SPI0_CS_CPHA 
    BCM2835_SPI0_CS_CS 
    BCM2835_SPI_BIT_ORDER_LSBFIRST
    BCM2835_SPI_BIT_ORDER_MSBFIRST
    BCM2835_SPI_MODE0 
    BCM2835_SPI_MODE1
    BCM2835_SPI_MODE2
    BCM2835_SPI_MODE3 
    BCM2835_SPI_CS0 
    BCM2835_SPI_CS1 
    BCM2835_SPI_CS2 
    BCM2835_SPI_CS_NONE 
    BCM2835_SPI_CLOCK_DIVIDER_65536
    BCM2835_SPI_CLOCK_DIVIDER_32768 
    BCM2835_SPI_CLOCK_DIVIDER_16384
    BCM2835_SPI_CLOCK_DIVIDER_8192
    BCM2835_SPI_CLOCK_DIVIDER_4096 
    BCM2835_SPI_CLOCK_DIVIDER_2048 
    BCM2835_SPI_CLOCK_DIVIDER_1024
    BCM2835_SPI_CLOCK_DIVIDER_512 
    BCM2835_SPI_CLOCK_DIVIDER_256
    BCM2835_SPI_CLOCK_DIVIDER_128 
    BCM2835_SPI_CLOCK_DIVIDER_64
    BCM2835_SPI_CLOCK_DIVIDER_32 
    BCM2835_SPI_CLOCK_DIVIDER_16
    BCM2835_SPI_CLOCK_DIVIDER_8
    BCM2835_SPI_CLOCK_DIVIDER_4
    BCM2835_SPI_CLOCK_DIVIDER_2
    BCM2835_SPI_CLOCK_DIVIDER_1
    ) );

#------------------------------------------------------------
# Defines for PWM
#------------------------------------------------------------

use constant {
    BCM2835_PWM_CONTROL     => 0,
    BCM2835_PWM_STATUS      => 1,
    BCM2835_PWM0_RANGE      => 4,
    BCM2835_PWM0_DATA       => 5,
    BCM2835_PWM1_RANGE      => 8,
    BCM2835_PWM1_DATA       => 9,

    BCM2835_PWMCLK_CNTL     => 40,
    BCM2835_PWMCLK_DIV      => 41,

    BCM2835_PWM1_MS_MODE   => 0x8000, # Run in MS mode
    BCM2835_PWM1_USEFIFO   => 0x2000, # Data from FIFO
    BCM2835_PWM1_REVPOLAR  => 0x1000, # Reverse polarity
    BCM2835_PWM1_OFFSTATE  => 0x0800, # Ouput Off state
    BCM2835_PWM1_REPEATFF  => 0x0400, # Repeat last value if FIFO empty
    BCM2835_PWM1_SERIAL    => 0x0200, # Run in serial mode
    BCM2835_PWM1_ENABLE    => 0x0100, # Channel Enable

    BCM2835_PWM0_MS_MODE   => 0x0080, # Run in MS mode
    BCM2835_PWM0_USEFIFO   => 0x0020, # Data from FIFO
    BCM2835_PWM0_REVPOLAR  => 0x0010, # Reverse polarity
    BCM2835_PWM0_OFFSTATE  => 0x0008, # Ouput Off state
    BCM2835_PWM0_REPEATFF  => 0x0004, # Repeat last value if FIFO empty
    BCM2835_PWM0_SERIAL    => 0x0002, # Run in serial mode
    BCM2835_PWM0_ENABLE    => 0x0001, # Channel Enable
};


_register_exported_constants( qw(
    pwm
    BCM2835_PWM_CONTROL
    BCM2835_PWM_STATUS
    BCM2835_PWM0_RANGE 
    BCM2835_PWM0_DATA
    BCM2835_PWM1_RANGE 
    BCM2835_PWM1_DATA 
    BCM2835_PWMCLK_CNTL
    BCM2835_PWMCLK_DIV 
    BCM2835_PWM1_MS_MODE
    BCM2835_PWM1_USEFIFO
    BCM2835_PWM1_REVPOLAR
    BCM2835_PWM1_OFFSTATE
    BCM2835_PWM1_REPEATFF
    BCM2835_PWM1_SERIAL
    BCM2835_PWM1_ENABLE
    BCM2835_PWM0_MS_MODE
    BCM2835_PWM0_USEFIFO
    BCM2835_PWM0_REVPOLAR
    BCM2835_PWM0_OFFSTATE
    BCM2835_PWM0_REPEATFF
    BCM2835_PWM0_SERIAL
    BCM2835_PWM0_ENABLE
    ) );



1;
