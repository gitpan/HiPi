#########################################################################################
# Package       HiPi::GPIO
# Description:  Base class for GPIO
# Created       Fri Nov 23 20:07:11 2012
# SVN Id        $Id: GPIO.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::GPIO;

#########################################################################################


=head1 NAME

HiPi::GPIO

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :pinmode );
    use HiPi::GPIO::PAD1;
    use HiPi::GPIO::PAD5;
   
    my $pad1 = HiPi::GPIO::PAD1->new;
    
    # Set RPi header pins 8 & 10 to output and value high
    
    for ( 8, 10 ) {
        $pad1->set_pin_mode($_, PIN_MODE_OUTPUT);
        $pad1->set_pin($_);
    }
     ...
     ...
    
    # we used the standard UART pins so we ought to set
    # them back to defaults
    
    $pad1->prepare_UART0();


=head1 DESCRIPTION

This module provides a base high level wrapper for Rasperry Pi GPIO access
using the lower level HiPi::BCM2835 as a backend through classes
HiPi::GPIO::PAD1 and HiPi::GPIO::PAD5

The Raspberry Pi provides pin out headers P1 and P5 ( although only
the 26 pin P1 has a surface mounted connector.)

These have pins numbered as follows: ( numbering follows physical
location on the header. )

PAD 1 ( P1 26 pins)    PAD 5 ( P5 8 pins )

    -----------        -----------
    |  1    2 |        |  1    2 | 
    |  3    4 |        |  3    4 | 
    |  5    6 |        |  5    6 | 
    |  7    8 |        |  7    8 |
    |  9   10 |        -----------
    | 11   12 | 
    | 13   14 | 
    | 15   16 |
    | 17   18 |
    | 19   20 |
    | 21   22 |     
    | 23   24 | 
    | 25   26 |
    -----------

The methods of  HiPi::GPIO::PADx expect the physical pin header
number as a pin identifier, so to set physical RPi pin 8 as an
output:

    $pad1->set_pin_mode(8, PIN_MODE_OUTPUT);

In reference manuals and other project code you may see reference to
the BCM GPIO pin numbers. These do not correspond to the Raspberry Pi
pin number physical layout above. The WiringPi C library has its own
pin numbering system, which is again different. Some pins can also be
referred to by name. The following tables provide a mapping for the
RPi numbers above to their names at their default settings, their BCM
GPIO numbers, and their WiringPi numbers. Please note that the
following layouts are provided aaccording to my understanding. If you
use them you accept that if you fry your Raspberry Pi as a consequence
it is entirely your own fault. If you want to be certain of correct
RPi pint out and mapping, research elsewhere.

 PAD 1 (P1 Header)

    WIRING  GPIO    NAME        RPI        NAME       GPIO  WIRING
    --------------------------------------------------------------
     -       -        3.3v  |  1    2 |   5.0V          -       -
     8       2    I2C0_SDA  |  3    4 |   5.0V          -       -
     9       3    I2C0_SCL  |  5    6 |   GND           -       -
     7       4     GPIO_04  |  7    8 |   UART0_TXD    14      15
     -       -         GND  |  9   10 |   UART0_RXD    15      16
     0      17     GPIO_17  | 11   12 |   GPIO_18      18       1
     2      27     GPIO_27  | 13   14 |   GND           -       -
     3      22     GPIO_22  | 15   16 |   GPIO_23      23       4
     -       -        3.3v  | 17   18 |   GPIO_24      24       5
    12      10   SPI0_MOSI  | 19   20 |   GND           -       -
    13       9   SPI0_MISO  | 21   22 |   GPIO_25      25       6
    14      11   SPI0_SCLK  | 23   24 |   SPI0_CE0_N    8      10
     -       -         GND  | 25   26 |   SPI0_CE1_N    7      11
    -------------------------------------------------------------

 PAD 5 (P5 Header)

    WIRING  GPIO    NAME        RPI        NAME       GPIO  WIRING
    --------------------------------------------------------------
     -       -        5.0V  |  1    2 |   3.3v          -       -
    17      28     GPIO_28  |  3    4 |   GPIO_29      29      18
    19      30     GPIO_30  |  5    6 |   GPIO_31      31      20
     -       -         GND  |  7    8 |   GND           -       -
    --------------------------------------------------------------

The HiPi::GPIO::PADx modules expect the physical Raspberry Pi
header pin number. So to set physical pin 8 from header P1 as an
output and then to set the pin high:

    use HiPi::GPIO::PAD1;
    use HiPi::Constant qw( :pinmode );
    
    my $pad1 = HiPi::GPIO::PAD1->new;
    $pad1->set_pin_mode(8, PIN_MODE_OUTPUT);
    $pad1->set_pin(8);

If you are translating code that uses the BCM GPIO pin id's or perhaps
the WiringPi pin id's you can simplify your task by exporting and using
the BCM pin constants or the WiringPi constants as required and using
these instead of the RPi pin literals.

For example, bcm2835 based code would identify the RPi header pi 8
as GPIO number 14. The WiringPi library would identify it as pin 15.

You don't have to translate manually using the above table:

    use HiPi::GPIO::PAD1;
    use HiPi::Constant qw( :pinmode :bcm2835);
    my $pad1 = HiPi::GPIO::PAD1->new;
    $pad1->set_pin_mode(BCM_14, PIN_MODE_OUTPUT);
    $pad1->set_pin(BCM_14);

or

    use HiPi::GPIO::PAD1;
    use HiPi::Constant qw( :pinmode :wiring);
    my $pad1 = HiPi::GPIO::PAD1->new;
    $pad1->set_pin_mode(WPI_PIN_15, PIN_MODE_OUTPUT);
    $pad1->set_pin(WPI_PIN_15);

=head1 METHODS

Where methods are wrappers for a corresponding bcm2835 library function
ful documentation can be found at L<http://www.open.com.au/mikem/bcm2835/modules.html>

=head2 new()
   
    my $pad1 = HiPi::GPIO::PAD1->new;
    my $pad5 = HiPi::GPIO::PAD5->new;

Returns a new HiPi::GPIO::PADx object

=head2 delay

    $obj->delay( $milliseconds )

Wrapper for the bcm2835_delay function.

=head2 delay_microseconds

    $obj->delay_microseconds( $microseconds )

Wrapper for the bcm2835_delayMicroseconds function.

=head2 set_pin_mode

    $obj->set_pin_mode( $pin, $iomode )

Wrapper for the bcm2835_gpio_fsel function.

=head2 write_pin

    $obj->set_pin_mode( $pin, $value )

Wrapper for the bcm2835_gpio_write function.

=head2 set_pin

    $obj->set_pin( $pin )

Wrapper for the bcm2835_gpio_set function.

=head2 clr_pin

    $obj->clr_pin( $pin )

Wrapper for the bcm2835_gpio_clr function.

=head2 read_pin

    my $val = $obj->read_pin( $pin )

Wrapper for the bcm2835_gpio_lev function.

=head2 set_pin_pud

    $obj->set_pin_pud( $pin, $value )

Wrapper for the bcm2835_gpio_set_pud function.

=head2 set_pin_afen

    $obj->set_pin_afen( $pin, $value )

Wrapper for the bcm2835_gpio_afen and bcm2835_gpio_clr_afen functions.

bcm2835_gpio_clr_afen is called if $value evaluates to false

=head2 set_pin_aren

    $obj->set_pin_aren( $pin, $value )

Wrapper for the bcm2835_gpio_aren and bcm2835_gpio_clr_aren functions.

bcm2835_gpio_clr_aren is called if $value evaluates to false

=head2 set_pin_fen

    $obj->set_pin_fen( $pin, $value )

Wrapper for the bcm2835_gpio_fen and bcm2835_gpio_clr_fen functions.

bcm2835_gpio_clr_fen is called if $value evaluates to false

=head2 set_pin_ren

    $obj->set_pin_ren( $pin, $value )

Wrapper for the bcm2835_gpio_ren and bcm2835_gpio_clr_ren functions.

bcm2835_gpio_clr_ren is called if $value evaluates to false


=head2 set_pin_hen

    $obj->set_pin_hen( $pin, $value )

Wrapper for the bcm2835_gpio_hen and bcm2835_gpio_clr_hen functions.

bcm2835_gpio_clr_hen is called if $value evaluates to false

=head2 set_pin_len

    $obj->set_pin_len( $pin, $value )

Wrapper for the bcm2835_gpio_len and bcm2835_gpio_clr_len functions.

bcm2835_gpio_clr_len is called if $value evaluates to false

=head2 get_pin_eds

    my $var = $obj->get_pin_eds( $pin )

Wrapper for the bcm2835_gpio_eds function.

=head2 clear_pin_eds

    $obj->clear_pin_eds( $pin )

Wrapper for the bcm2835_gpio_set_eds function.

=head2 spi_begin

    $obj->spi_begin()

Wrapper for the bcm2835_spi_begin function.

=head2 spi_end

    $obj->spi_end()

Wrapper for the bcm2835_spi_end function.

=head2 spi_set_bit_order

    $obj->spi_set_bit_order($order)

Wrapper for the bcm2835_spi_setBitOrder function.

=head2 spi_set_clock_divider

    $obj->spi_set_clock_divider($divider)

Wrapper for the bcm2835_spi_setClockDivider function.

=head2 spi_set_data_mode

    $obj->spi_set_data_mode($mode)

Wrapper for the bcm2835_spi_setDataMode function.

=head2 spi_chip_select

    $obj->spi_chip_select($chipselect)

Wrapper for the bcm2835_spi_chipSelect function.

=head2 spi_set_chip_select_polarity

    $obj->spi_set_chip_select_polarity($chipselect, $active)

Wrapper for the bcm2835_spi_setChipSelectPolarity function.

=head2 spi_transfer_byte

    $obj->spi_transfer_byte($value)

Wrapper for the bcm2835_spi_transfer function.

=head2 spi_transfer_buffer

    my $outbuffer = $obj->spi_transfer_buffer($inbuffer)

Wrapper for the bcm2835_spi_transfernb function.

=head2 get_pad_control

    my $ct = $obj->get_pad_control($padgroup)

Wrapper for the bcm2835_gpio_pad function.

=head2 set_pad_control

    $obj->set_pad_control($padgroup, $control)

Wrapper for the bcm2835_gpio_set_pad function.

=head2 prepare_UART0

    $obj->prepare_UART0()

Set up standard pins used for UART0

=head2 prepare_UART0_RTS

    $obj->prepare_UART0_RTS()

Set up standard pins used for UART0 with RTS

=head2 prepare_UART1

    $obj->prepare_UART1()

Set up standard pins used for UART1

=head2 prepare_UART1_RTS

    $obj->prepare_UART1_RTS()

Set up standard pins used for UART1 with RTS

=head2 prepare_I2C0

    $obj->prepare_I2C0()

Set up standard pins used for I2C0

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


use HiPi;
use strict;
use warnings;
use Carp;
use Exporter;
use base qw( Exporter );

use threads::shared;
use HiPi::BCM2835;
use Carp;
use HiPi::Constant qw( :serial :i2c );

our $_debug_level = 0;
share( $_debug_level );
our $_gpio_use_count : shared;
our $_thrlock : shared;

sub set_debug {
    lock $_thrlock;
    $_debug_level = $_[0];
}

sub _inc_gpio_use_count {
    my $count;
    {
        lock $_thrlock;
        $_gpio_use_count ++;
        $count = $_gpio_use_count;
        if( $count == 1 ) {
            HiPi::BCM2835::bcm2835_set_debug($_debug_level);
            HiPi::BCM2835::bcm2835_init() or croak( 'Failed to initialise bcm2835 library' );
        }
    }
    return $count
}

sub _dec_gpio_use_count {
    my $count;
    {
        lock $_thrlock;
        $_gpio_use_count --;
        $count = $_gpio_use_count;
        if( $count == 0 ) {
            HiPi::BCM2835::bcm2835_close() or croak( 'Failed to close bcm2835 library' );
        }
        croak( 'Attempt to decrease GPIO use count below zero' ) if $count < 0;
    }
    return $count
}

sub new {
    my ($class, $pad2gpio) = @_;
    my $self = bless {}, $class;
    $self->{_pad2gpio}   = $pad2gpio;
    $self->{_numpins}    = @$pad2gpio;
    &_inc_gpio_use_count;
    return $self;
}

sub DESTROY {
    my $self = shift;
    &_dec_gpio_use_count;
}

sub trans_pad2gpio {
    my($self, $padpin) = @_;
    if( $padpin < 1 || $padpin > $self->{_numpins} ) {
        croak('class ' . ref($self) . qq( has no pin numbered $padpin));
    }
    my $rval = $self->{_pad2gpio}->[$padpin -1];
    carp('class ' . ref($self) . qq( pin $padpin is undefined) ) unless defined($rval);
    return $rval;
}

sub delay {
    my($self, $milliseconds) = @_;
    HiPi::BCM2835::bcm2835_delay( $milliseconds );
}

sub delay_microseconds {
    my($self, $microseconds) = @_;
    HiPi::BCM2835::bcm2835_delayMicroseconds( $microseconds );
}

sub set_pin_mode {
    my( $self, $pin, $iomode ) = @_;
    HiPi::BCM2835::bcm2835_gpio_fsel($self->trans_pad2gpio($pin), $iomode);
}

sub write_pin {
    my($self, $pin, $value) = @_;
    HiPi::BCM2835::bcm2835_gpio_write($self->trans_pad2gpio($pin), $value);
}

sub set_pin {
    my($self, $pin) = @_;
    HiPi::BCM2835::bcm2835_gpio_set($self->trans_pad2gpio($pin));
}

sub clr_pin {
    my($self, $pin) = @_;
    HiPi::BCM2835::bcm2835_gpio_clr($self->trans_pad2gpio($pin));
}

sub read_pin {
    my($self, $pin) = @_;
    HiPi::BCM2835::bcm2835_gpio_lev($self->trans_pad2gpio($pin));
}

sub set_pin_pud {
    my($self, $pin, $value) = @_;
    HiPi::BCM2835::bcm2835_gpio_set_pud($self->trans_pad2gpio($pin), $value);
}

sub set_pin_afen {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_afen($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_afen($self->trans_pad2gpio($pin));
    }
}

sub set_pin_aren {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_aren($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_aren($self->trans_pad2gpio($pin));
    }
}

sub set_pin_fen {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_fen($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_fen($self->trans_pad2gpio($pin));
    }
}

sub set_pin_ren {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_ren($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_ren($self->trans_pad2gpio($pin));
    }
}

sub set_pin_hen {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_hen($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_hen($self->trans_pad2gpio($pin));
    }
}

sub set_pin_len {
    my($self, $pin, $value) = @_;
    if($value) {
        HiPi::BCM2835::bcm2835_gpio_len($self->trans_pad2gpio($pin));
    } else {
        HiPi::BCM2835::bcm2835_gpio_clr_len($self->trans_pad2gpio($pin));
    }
}

sub get_pin_eds {
    my($self, $pin) = @_;
    HiPi::BCM2835::bcm2835_gpio_eds($self->trans_pad2gpio($pin));
}

sub clear_pin_eds {
    my($self, $pin) = @_;
    HiPi::BCM2835::bcm2835_gpio_set_eds($self->trans_pad2gpio($pin));
} 


sub spi_begin {
    HiPi::BCM2835::bcm2835_spi_begin();
}

sub spi_end {
    HiPi::BCM2835::bcm2835_spi_end();
}

sub spi_set_bit_order {
    my($self, $order) = @_;
    HiPi::BCM2835::bcm2835_spi_setBitOrder($order);
}

sub spi_set_clock_divider {
    my($self, $divider) = @_;
    HiPi::BCM2835::bcm2835_spi_setClockDivider($divider);
}

sub spi_set_data_mode {
    my($self, $mode) = @_;
    HiPi::BCM2835::bcm2835_spi_setDataMode($mode);
}

sub spi_chip_select {
    my($self, $cs) = @_;
    HiPi::BCM2835::bcm2835_spi_chipSelect($cs);
}

sub spi_set_chip_select_polarity {
    my($self, $cs, $active) = @_;
    HiPi::BCM2835::bcm2835_spi_setChipSelectPolarity($cs, $active);
}

sub spi_transfer_byte {
    my($self, $value) = @_;
    HiPi::BCM2835::bcm2835_spi_transfer($value);
}

sub spi_transfer_buffer {
    my($self, $buffer) = @_;
    my $len = length($buffer);
    my $transend = $buffer;
    my $tranrecv = $buffer;
    HiPi::BCM2835::bcm2835_spi_transfernb($transend, $tranrecv, $len);
    return $tranrecv;
}

sub get_pad_control {
    my($self, $padgroup) = @_;
    HiPi::BCM2835::bcm2835_gpio_pad( $padgroup );
}

sub set_pad_control {
    my($self, $padgroup, $control) = @_;
    HiPi::BCM2835::bcm2835_gpio_set_pad( $padgroup, $control );
}

sub prepare_UART0 {
    my $self = shift;
    $self->set_pin_mode( UART0_TXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
    $self->set_pin_mode( UART0_RXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
}

sub prepare_UART0_RTS {
    my $self = shift;
    $self->set_pin_mode( UART0_TXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
    $self->set_pin_mode( UART0_RXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
    $self->set_pin_mode( UART0_RTS, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT3 );
}

sub prepare_UART1 {
    my $self = shift;
    $self->set_pin_mode( UART1_TXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT5 );
    $self->set_pin_mode( UART1_RXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT5 );
}

sub prepare_UART1_RTS {
    my $self = shift;
    $self->set_pin_mode( UART1_TXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT5 );
    $self->set_pin_mode( UART1_RXD, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT5 );
    $self->set_pin_mode( UART1_RTS, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT5 );
}

sub prepare_I2C0 {
    my $self = shift;
    $self->set_pin_mode( I2C0_SDA, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
    $self->set_pin_mode( I2C0_SCL, &HiPi::BCM2835::BCM2835_GPIO_FSEL_ALT0 );
}



1;
