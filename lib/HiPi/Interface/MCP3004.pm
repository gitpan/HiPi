#########################################################################################
# Package       HiPi::Interface::MCP3004
# Description:  Control MCP3004 Analog 2 Digital
# Created       Sun Dec 02 01:42:27 2012
# SVN Id        $Id: MCP3004.pm 1077 2013-03-13 10:05:06Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Interface::MCP3004;

#########################################################################################

use strict;
use warnings;
use parent qw( HiPi::Interface );
use Carp;
use HiPi::Device::SPI qw( :spi );

__PACKAGE__->create_accessors( qw( devicename ) );

our $VERSION = '0.20';

our @EXPORT = ();
our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use constant {
    MCP3004_S0        => 0b00001000,  # single-ended CH0
    MCP3004_S1        => 0b00001001,  # single-ended CH1
    MCP3004_S2        => 0b00001010,  # single-ended CH2
    MCP3004_S3        => 0b00001011,  # single-ended CH3
    MCP3004_DIFF_0_1  => 0b00000000,  # differential +CH0 -CH1
    MCP3004_DIFF_1_0  => 0b00000001,  # differential -CH0 +CH1
    MCP3004_DIFF_2_3  => 0b00000010,  # differential +CH2 -CH3
    MCP3004_DIFF_3_2  => 0b00000011,  # differential -CH2 +CH3
};

{
    my @const = qw(
        MCP3004_S0 MCP3004_S1 MCP3004_S2 MCP3004_S3
        MCP3004_DIFF_0_1 MCP3004_DIFF_1_0
        MCP3004_DIFF_2_3 MCP3004_DIFF_3_2
    );
    push( @EXPORT_OK, @const );
    $EXPORT_TAGS{mcp} = \@const;
}

sub new {
    my( $class, %userparams ) = @_;
    
    my %params = (
        devicename   => '/dev/spidev0.0',
        speed        => SPI_SPEED_MHZ_1,
        bitsperword  => 8,
        delay        => 0,
        device       => undef,
    );
    
    foreach my $key (sort keys(%userparams)) {
        $params{$key} = $userparams{$key};
    }
    
    unless( defined($params{device}) ) {
        my $dev = HiPi::Device::SPI->new(
            speed        => $params{speed},
            bitsperword  => $params{bitsperword},
            delay        => $params{delay},
            devicename   => $params{devicename},
        );
        
        $params{device} = $dev;
    }
    
    my $self = $class->SUPER::new(%params);
    
    # MCP3004 may need a dummy read on first use after boot
    # as the chip needs the CS line to transition low/hi at
    # least once if it is booted when CS is low
    
    $self->read(MCP3004_S0);
    
    return $self;
}


sub read {
    my($self, $mode) = @_;
    my @buffers  = (1, $mode << 4, 0 );
    my @result = unpack('C3', $self->device->transfer( pack('C3', @buffers) ));
    return (($result[1] & 3) << 8) + $result[2];
}

1;

__END__