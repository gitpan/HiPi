#########################################################################################
# Package       HiPi::BCM2835::I2C
# Description:  I2C Connection
# Created       Wed Mar 13 13:40:32 2013
# SVN Id        $Id: I2C.pm 1435 2013-03-17 01:59:15Z Mark Dootson $
# Copyright:    Copyright (c) 2013 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::BCM2835::I2C;

#########################################################################################

use strict;
use warnings;
use parent qw( HiPi::Class );
use HiPi::BCM2835 qw( :registers :i2c :clock );
use HiPi::Constant qw( :raspberry :i2c );
use Carp;

__PACKAGE__->create_accessors( qw(
    _hipi_baseaddr peripheral address
));

our $VERSION = '0.22';

our @EXPORT = ();
our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use constant {
    BB_I2C_PERI_0         => 0x10,
    BB_I2C_PERI_1         => 0x20,
    BB_I2C_RESULT_SUCCESS => BCM2835_I2C_REASON_OK,
    BB_I2C_RESULT_NACKRCV => BCM2835_I2C_REASON_ERROR_NACK,
    BB_I2C_RESULT_CLOCKTO => BCM2835_I2C_REASON_ERROR_CLKT,
    BB_I2C_RESULT_DATAERR => BCM2835_I2C_REASON_ERROR_DATA,
    BB_I2C_CLOCK_100_KHZ  => 2500,
    BB_I2C_CLOCK_400_KHZ  => 626,
    BB_I2C_CLOCK_1667_KHZ => 150,
    BB_I2C_CLOCK_1689_KHZ => 148,
};

{
    my @const = qw(
        BB_I2C_PERI_0
        BB_I2C_PERI_1
        BB_I2C_RESULT_SUCCESS 
        BB_I2C_RESULT_NACKRCV
        BB_I2C_RESULT_CLOCKTO
        BB_I2C_RESULT_DATAERR
        BB_I2C_CLOCK_100_KHZ
        BB_I2C_CLOCK_400_KHZ
        BB_I2C_CLOCK_1667_KHZ
        BB_I2C_CLOCK_1689_KHZ
    );
    
    push @EXPORT_OK, @const;
    $EXPORT_TAGS{i2c} = \@const;
}


sub set_baudrate {
    my ($class, $channel, $newval) = @_;
    # make sure library is initialised
    HiPi::BCM2835::bcm2835_init();
    #HiPi::BCM2835::bcm2835_set_baudrate($newval);
    #return;
    my $baseaddress = ( $channel == BB_I2C_PERI_1 )
        ? BCM2835_BSC1_BASE
        : BCM2835_BSC0_BASE;
    my $cdiv = int( BCM2835_CORE_CLK_HZ / $newval ) & 0x3FFFFE;
    HiPi::BCM2835::_hipi_i2c_setClockDivider( $baseaddress, $cdiv );
}

sub get_baudrate {
    my ($class, $channel) = @_;
    # make sure library is initialised
    
    unless( $channel ) {
        $channel = ( RPI_BOARD_REVISION == 1 ) ? BB_I2C_PERI_0 : BB_I2C_PERI_1;
    }
    
    HiPi::BCM2835::bcm2835_init();
    my $baseaddress = ( $channel == BB_I2C_PERI_1 )
        ? BCM2835_BSC1_BASE
        : BCM2835_BSC0_BASE;
    
    my $readaddess = $baseaddress + BCM2835_BSC_DIV;
    my $cdiv = HiPi::BCM2835::bcm2835_peri_read($readaddess);
    # return value with least significant part munged
    # to meet user expectation
    return (BCM2835_CORE_CLK_HZ / $cdiv ) & 0x3FFFFE;
}

sub new {
    my ($class, %userparams ) = @_;
        
    my %params = (
        address      => 0,
        peripheral   => ( RPI_BOARD_REVISION == 1 ) ? BB_I2C_PERI_0 : BB_I2C_PERI_1,
    );
    
    # get user params
    foreach my $key( keys (%userparams) ) {
        $params{$key} = $userparams{$key};
    }
    
    # force PERI_I2C_0 on revision 1 board
    if( RPI_BOARD_REVISION == 1 ) {
        $params{peripheral} = BB_I2C_PERI_0;
    }
    
    # initialise
    HiPi::BCM2835::bcm2835_init();
    
    $params{_hipi_baseaddr} = ( $params{peripheral} == BB_I2C_PERI_1 )
        ? BCM2835_BSC1_BASE
        : BCM2835_BSC0_BASE;

    my $self = $class->SUPER::new(%params);
    
    $self->i2c_begin();
    
    return $self;
}

sub i2c_begin {
    my $self = shift;
    # note that set_I2C_X does the right thing
    # according to board revision
    # ALSO sets pull up resistor on / off
    if ( $self->peripheral == BB_I2C_PERI_1 ) {
        HiPi::BCM2835::hipi_set_I2C1(1);
    } else {
        HiPi::BCM2835::hipi_set_I2C0(1);
    }
}

# i2c_end - we don't call this automatically
# as removing the pu resistors may be
# unexpected
sub i2c_end {
    my $self = shift;
    # note that set_I2C_X does the right thing
    # according to board revision
    # ALSO sets pull up resistor on / off
    if ( $self->peripheral == BB_I2C_PERI_1 ) {
        HiPi::BCM2835::hipi_set_I2C1(0);
    } else {
        HiPi::BCM2835::hipi_set_I2C0(0);
    }
}

#sub i2c_setSlaveAddress {
#    my( $self, $newaddress ) = @_;
#    $self->address( $newaddress );
#    HiPi::BCM2835::_hipi_i2c_setSlaveAddress( $self->_hipi_baseaddr, $self->address );
#}

sub i2c_write {
    my( $self, @bytes ) = @_;
    my $writebuffer = pack('C*', @bytes);
    HiPi::BCM2835::_hipi_i2c_setSlaveAddress( $self->_hipi_baseaddr, $self->address );
    my $error = HiPi::BCM2835::_hipi_i2c_write( $self->_hipi_baseaddr, $writebuffer, scalar @bytes );
    croak qq(i2c_write failed with return value $error) if $error;
}

sub i2c_read {
    my( $self, $numbytes ) = @_;
    $numbytes ||= 1;
    my $readbuffer = chr(0) x  ( $numbytes + 1 );
    HiPi::BCM2835::_hipi_i2c_setSlaveAddress( $self->_hipi_baseaddr, $self->address );
    my $error = HiPi::BCM2835::_hipi_i2c_read($self->_hipi_baseaddr, $readbuffer, $numbytes);
    croak qq(i2c_read failed with return value $error) if $error;
    my $template = ( $numbytes > 1 ) ? 'C' . $numbytes : 'C';
    my @values = unpack($template, $readbuffer);
    return @values;
}


sub i2c_read_register {
    my( $self, $register, $numbytes ) = @_;
    $numbytes ||= 1;
    my $writebuffer = pack('C', $register);
    my $readbuffer = '0' x $numbytes;
    HiPi::BCM2835::_hipi_i2c_setSlaveAddress( $self->_hipi_baseaddr, $self->address );
    my $error = HiPi::BCM2835::_hipi_i2c_read_register($self->_hipi_baseaddr, $writebuffer, $readbuffer, $numbytes);
    croak qq(i2c_read_register failed with return value $error) if $error;
    my $template  = ( $numbytes > 1 ) ? 'C' . $numbytes : 'C';
    my @values = unpack($template, $readbuffer);
    return @values;
}


sub i2c_read_register_rs {
    my( $self, $register, $numbytes) = @_;
    $numbytes ||= 1;
    my $writebuffer = pack('C', $register);
    my $readbuffer = '0' x ( $numbytes + 1 );
    HiPi::BCM2835::_hipi_i2c_setSlaveAddress( $self->_hipi_baseaddr, $self->address );
    my $error = HiPi::BCM2835::_hipi_i2c_read_register_rs( $self->_hipi_baseaddr, $writebuffer, $readbuffer, $numbytes );
    croak qq(i2c_read_register_rs failed with error $error) if $error;
    my $template = ( $numbytes > 1 ) ? 'C' . $numbytes : 'C';
    my @values = unpack($template, $readbuffer);    
    return @values;
}

sub delay {
    my($class, $millis) = @_;
    HiPi::BCM2835::bcm2835_delay( $millis );
}

sub delayMicroseconds {
    my($class, $micros) = @_;
    HiPi::BCM2835::bcm2835_delayMicroSeconds( $micros );
}

#-------------------------------------
# Common I2C busmode methods
# bus_write
# bus_read
# bus_write_bits
# bus_read_bits
#-------------------------------------

sub bus_write { shift->i2c_write( @_ ); }

sub bus_read { shift->i2c_read_register( @_ ); }

sub bus_read_bits {
    my($self, $regaddr, $numbytes) = @_;
    $numbytes ||= 1;
    my @bytes = $self->i2c_read_register($regaddr, $numbytes);
    my @bits;
    while( defined(my $byte = shift @bytes )) {
        my $checkbits = 0b00000001;
        for( my $i = 0; $i < 8; $i++ ) {
            my $val = ( $byte & $checkbits ) ? 1 : 0;
            push( @bits, $val );
            $checkbits *= 2;
        }
    }
    return @bits;
}

sub bus_write_bits {
    my($self, $register, @bits) = @_;
    my $bitcount  = @bits;
    my $bytecount = $bitcount / 8;
    if( $bitcount % 8 ) { croak(qq(The number of bits $bitcount cannot be ordered into bytes)); }
    my @bytes;
    while( $bytecount ) {
        my $byte = 0;
        for(my $i = 0; $i < 8; $i++ ) {
            $byte += ( $bits[$i] << $i );   
        }
        push(@bytes, $byte);
        $bytecount --;
    }
    $self->i2c_write($register, @bytes);
}

1;
