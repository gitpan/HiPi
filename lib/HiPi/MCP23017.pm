#########################################################################################
# Package       HiPi::MCP23017
# Description:  Control MCP23017 Port Extender via I2C
# Created       Sun Dec 02 01:42:27 2012
# SVN Id        $Id: MCP23017.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::MCP23017;

#########################################################################################

=head1 NAME

HiPi::MCP23017

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :mcp23017 );
    use HiPi::MCP23017;
    
    my $mcp = HiPi::MCP23017->new;
    
    my @bits = (0,0,0,0,0,0,0,0);
    
    # set all pins on port A as output
    $mcp->write_register_bits('IODIRA', @bits);
    
    # set level of all pins on port A low
    $mcp->write_register_bits('GPIOA', @bits);
    
    # set level of port A pin 7 high
    @bits = $mcp->read_register_bits('GPIOA');
    $bits[7] = 1;
    $mcp->write_register_bits('GPIOA', @bits);
    
    # check level of port A pin 3
    @bits = $mcp->read_register_bits('GPIOA');
    my $val = $bits[3];


=head1 DESCRIPTION

This module provides an interface to the popular MCP23017 IO expander.
(The I2C version )

=head1 METHODS

=head2 new

    my $mcp = HiPi::MCP23017->new;
    
    my $mcp = HiPi::MCP23017->new( {
        i2caddress   => 0x20,
        devicename   => '/dev/i2c-1' } );

=head2 write_register_bits

    $mcp->write_register_bits($register, @bits);

Write an array of 8 bit values ( 0 or 1 ) to the specified register.
   
$bits[0] is written to register bit 0

$bits[7] is written to register bit 7
    
Valid values for $register are the register names:

    'IODIRA', 'IPOLA', 'GPINTENA', 'DEFVALA', INTCONA',
    'IOCON', 'GPPUA', 'INTFA', 'INTCAPA', 'GPIOA','OLATA',
    'IODIRB', 'IPOLB', 'GPINTENB', 'DEFVALB', 'INTCONB',
    'GPPUB', 'INTFB', 'INTCAPB', 'GPIOB','OLATB'

=head2 read_register_bits

    my @bits = $mcp->write_register_bits($register);

Read an array of 8 bit values ( 0 or 1 ) from the specified register.
   
$bits[0] is populated from register bit 0

$bits[7] is populated from register bit 7

Valid values for $register are the register names:

    'IODIRA', 'IPOLA', 'GPINTENA', 'DEFVALA', INTCONA',
    'IOCON', 'GPPUA', 'INTFA', 'INTCAPA', 'GPIOA','OLATA',
    'IODIRB', 'IPOLB', 'GPINTENB', 'DEFVALB', 'INTCONB',
    'GPPUB', 'INTFB', 'INTCAPB', 'GPIOB','OLATB'

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


use strict;
use warnings;
use HiPi::Class;
use base qw( HiPi::Class );
use Carp;

__PACKAGE__->create_accessors( qw( systemdevice i2caddress ) );

our %regaddress;

sub set_register_addresses {
    my( $selforclass, $bank) = @_;
    if( $bank == 1 ) {
        $regaddress{IODIRA}   = 0x00;
        $regaddress{IPOLA}    = 0x01;
        $regaddress{GPINTENA} = 0x02;
        $regaddress{DEFVALA}  = 0x03;
        $regaddress{INTCONA}  = 0x04;
        $regaddress{IOCON}    = 0x05;
        $regaddress{GPPUA}    = 0x06;
        $regaddress{INTFA}    = 0x07;
        $regaddress{INTCAPA}  = 0x08;
        $regaddress{GPIOA}    = 0x09;
        $regaddress{OLATA}    = 0x0A;
        $regaddress{IODIRB}   = 0x10;
        $regaddress{IPOLB}    = 0x11;
        $regaddress{GPINTENB} = 0x12;
        $regaddress{DEFVALB}  = 0x13;
        $regaddress{INTCONB}  = 0x14;
        $regaddress{GPPUB}    = 0x16;
        $regaddress{INTFB}    = 0x17;
        $regaddress{INTCAPB}  = 0x18;
        $regaddress{GPIOB}    = 0x19;
        $regaddress{OLATB}    = 0x1A;
    } else {
        $regaddress{IODIRA}   = 0x00;
        $regaddress{IODIRB}   = 0x01;
        $regaddress{IPOLA}    = 0x02;
        $regaddress{IPOLB}    = 0x03;
        $regaddress{GPINTENA} = 0x04;
        $regaddress{GPINTENB} = 0x05;
        $regaddress{DEFVALA}  = 0x06;
        $regaddress{DEFVALB}  = 0x07;
        $regaddress{INTCONA}  = 0x08;
        $regaddress{INTCONB}  = 0x09;
        $regaddress{IOCON}    = 0x0A;
        $regaddress{GPPUA}    = 0x0C;
        $regaddress{GPPUB}    = 0x0D;
        $regaddress{INTFA}    = 0x0E;
        $regaddress{INTFB}    = 0x0F;
        $regaddress{INTCAPA}  = 0x10;
        $regaddress{INTCAPB}  = 0x11;
        $regaddress{GPIOA}    = 0x12;
        $regaddress{GPIOB}    = 0x13;
        $regaddress{OLATA}    = 0x14;
        $regaddress{OLATB}    = 0x15;
    }
}

__PACKAGE__->set_register_addresses(0);

sub new {
    my ($class, $userparams) = @_;
    
    my %params = (
        i2caddress   => 0x20,
        systemdevice => undef,
        devicename   => '/dev/i2c-1',
    );
    
    # get user params
    foreach my $key( keys (%$userparams) ) {
        $params{$key} = $userparams->{$key};
    }
    
    unless( defined($params{systemdevice}) ) {
        require HiPi::Device::I2C;
        my $dev = HiPi::Device::I2C->new($params{devicename});
        $dev->select_address($params{i2caddress});
        $params{systemdevice} = $dev;
    }
    
    my $self = $class->SUPER::new(\%params);
    return $self;
}

sub read_register_bits {
    my($self, $register, $numbytes) = @_;
    my @bytes = $self->read_register_bytes($register, $numbytes);
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

sub read_register_bytes {
    my($self, $register, $numbytes) = @_;
    croak(qq(Register $register is not recognised)) unless( exists($regaddress{$register}) );
    my $raddr = $regaddress{$register};
    $numbytes ||= 1;
    my @rvals = ( $self->systemdevice->smbus_read($raddr, $numbytes) );
    # Check if address bank changed
    if( $register eq 'IOCON' ) {
        my $bank = ( $rvals[0] & 0b10000000 ) ? 1 : 0;
        $self->set_register_addresses($bank);
    }
    return @rvals;
}

sub write_register_bits {
    my($self, $register, @bits) = @_;
    
    my $bitcount  = @bits;
    my $bytecount = $bitcount / 8;
    
    if( $bitcount % 8 ) {
        croak(qq(The number of bits $bitcount cannot be ordered into bytes));
    }
    
    my @bytes;
    while( $bytecount ) {
        my $byte = 0;
        my $checkbits = 0b00000001;
        for(my $i = 0; $i < 8; $i++ ) {
            my $val = shift @bits;
            $byte += $checkbits if $val;
            $checkbits *= 2;
        }
        push(@bytes, $byte);
        $bytecount --;
    }
    
    $self->write_register_bytes($register,@bytes);
}

sub write_register_bytes {
    my($self, $register, @bytes) = @_;
    
    croak(qq(Register $register is not recognised)) unless( exists($regaddress{$register}) );
    my $raddr = $regaddress{$register};
    
    my $result = $self->systemdevice->smbus_write($raddr, @bytes);
    
    # Check if address bank changed
    if( $register eq 'IOCON' ) {
        my $bank = ( $bytes[0] & 0b10000000 ) ? 1 : 0;
        $self->set_register_addresses($bank);
    }
    return $result;
}


1;
