#########################################################################################
# Package       HiPi::Device::SerialPort
# Description:  Serial Port driver
# Created       Sat Nov 24 19:29:33 2012
# SVN Id        $Id: SerialPort.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Device::SerialPort;

#########################################################################################

=head1 NAME

HiPi::Device::SerialPort

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Device::SerialPort;
    
    my $serial = HiPi::Device::SerialPort->new(
        {
            devicename      => '/dev/ttyAMA0',
            baudrate        => 9600,
            parity          => 'none',
            stopbits        => 1,
            databits        => 8,
        }
    );


=head1 DESCRIPTION

This module is not normally used directly in end user code. It supports serial port access for other serial devices / controls
    
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
use HiPi::Device;
use base qw( HiPi::Device );
use Carp;
use Try::Tiny;
use HiPi::GPIO::PAD1;
require Device::SerialPort;

__PACKAGE__->create_accessors( qw( portopen baudrate parity stopbits databits driver ) );

sub new {
    my( $class, $userparams ) = @_;
    
    my %params = (
        # standard device
        devicename      => '/dev/ttyAMA0',
        
        # serial port
        baudrate        => 9600,
        parity          => 'none',
        stopbits        => 1,
        databits        => 8,
        
        # this
        driver          => undef,
        portopen        => 0,
        
    );
    
    # get user params
    foreach my $key( keys (%params) ) {
        $params{$key} = $userparams->{$key} if exists($userparams->{$key});
    }
    
    # warn user about unsupported params
    foreach my $key( keys (%$userparams) ) {
        carp(qq(unknown parameter name ) . $key) if not exists($params{$key});
    }
    
    # Make sure UARTn pins are correctly setup for standard ports
    {
        my $initpad = HiPi::GPIO::PAD1->new;
        if( $params{devicename} eq '/dev/ttyAMA0') {
            $initpad->prepare_UART0;
        }
        if( $params{devicename} eq '/dev/ttyAMA1') {
            $initpad->prepare_UART1;
        }
        
    }
    
    my $driver = Device::SerialPort->new( $params{devicename} ) or
        croak qq(unable to open device $params{devicename});
    
    try {
        $driver->baudrate($params{baudrate});
        $driver->parity($params{parity});
        $driver->stopbits($params{stopbits});
        $driver->databits($params{databits});
        $driver->handshake('none');
        $driver->write_settings;
    } catch {
        croak(qq(failed to set serial port params : $_) );
    };
    
    $params{driver}   = $driver;
    $params{portopen} = 1;
    
    my $self = $class->SUPER::new( \%params ) ;
    
    return $self;
}

sub write {
    my($self, $buffer) = @_;
    return unless $self->portopen;
    my $result = $self->driver->write($buffer);
    $self->driver->write_drain;
    return $result;
    
}

sub close {
    return unless $_[0]->portopen;
    $_[0]->portopen( 0 );
    $_[0]->driver->close or croak q(failed to close serial port);
    $_[0]->driver( undef );                  
}

1;
