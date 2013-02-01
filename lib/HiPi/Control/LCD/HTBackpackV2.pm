#########################################################################################
# Package       HiPi::Control::LCD::HTBackpackV2
# Description:  HobbyTronics BackpackV2 LCD Controller
# Created       Sat Nov 24 20:46:14 2012
# SVN Id        $Id: HTBackpackV2.pm 451 2013-02-01 19:44:12Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Control::LCD::HTBackpackV2;

#########################################################################################

=head1 NAME

HiPi::Control::LCD::HTBackpackV2

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :raspberry :pinmode :serial
        :spi :i2c :wiring :bcm2835 :mcp23017 :htv2cmd
        :htv2baudrate );
    
    use HiPi::Control::LCD qw( :cursor :hd44780 );
    use HiPi::Control::LCD::HTBackpackV2;
    
    my $hp = HiPi::Control::LCD::HTBackpackV2->new(
        { width => 16, lines => 2, backlightcontrol => 1, devicetype => 'serialrx' } );
    # my $hp = HiPi::Control::LCD::HTBackpackV2->new(
    #   { width => 16, lines => 4, backlightcontrol => 1, devicetype => 'i2c' } );
    
    $hp->enable(1);
		
    $hp->backlight(25);
    $hp->clear;

    $hp->set_cursor_position(0,0);
    $hp->send_text('Raspberry Pi');

    $hp->set_cursor_position(0,1);
    $hp->send_text('HobbyTronics Backpack');


=head1 DESCRIPTION

This module inherits from HiPi::Control::LCD to provide an access to 
the HobbyTronics Version 2 Backpack (serialRX and I2C ) LCD interface.

=head1 METHODS

Common methods used by all HiPi::Control::LCD::xx classes can be found in the
HiPi::Control::LCD pod.

HiPi::Control::LCD::HTBackpackV2 specific methods are

=head2 change_i2c_address

    $lcd->change_i2c_address($newaddress);

Change the I2C address if using in i2c mode.

The i2c address must be in the range 1 - 127 ( 0x01 - 0x7F )

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
use HiPi::Control::LCD;
use base qw( HiPi::Control::LCD );
use feature qw( switch );
use Carp;
use HiPi::Constant qw( :htv2baud :htv2cmd );

our $VERSION = '0.01';

__PACKAGE__->create_accessors( qw( devicetype i2caddress ) );

use constant {
    HTV2_END_SERIALRX_COMMAND    => chr(0xFF),
};

sub new {
    my( $class, $userparams)  = @_;
    
    my %params = (
        # LCD
        width            =>  undef,
        lines            =>  undef,
        backlightcontrol =>  0,
        systemdevice     =>  undef,
        positionmap      =>  undef,
        
        # RX or i2c
        devicetype        => 'i2c', # alt [serialrx|i2c]
        devicename        => undef,
        
        
        # SerialRX params
        serial_devicename => '/dev/ttyAMA0',
        baudrate          => 9600,
        parity            => 'none',
        stopbits          => 1,
        databits          => 8,
        
        # i2c params
        i2caddress        => 0x3A,
        i2cdevice         => undef,
        i2c_devicename    => '/dev/i2c-1',
        
    );
    
    # get user params
    foreach my $key( keys (%$userparams) ) {
        $params{$key} = $userparams->{$key};
    }
    
    unless( defined($params{systemdevice}) ) {
        if( $params{devicetype} eq 'serialrx' ) {
            # set a default port
            $params{devicename} = $params{serial_devicename} unless $params{devicename};
            my %portparams;
            for (qw( devicename baudrate parity stopbits databits ) ) {
                $portparams{$_} = $params{$_};
            }
            require HiPi::Device::SerialPort;
            $params{systemdevice} = HiPi::Device::SerialPort->new(\%portparams);
        } elsif( $params{devicetype} eq 'i2c' ) {
            $params{devicename} = $params{i2c_devicename} unless $params{devicename};
            $params{systemdevice} = HiPi::Control::LCD::HTBackpackV2::I2C->new({
                devicename => $params{devicename},
                address    => $params{i2caddress},
                i2cdevice  => $params{i2cdevice},
            });
        }
    }
    
    my $self = $class->SUPER::new(\%params);
    return $self;
}

sub send_text {
    my($self, $text) = @_;
    $self->send_htv2_command( HTV2_CMD_PRINT, $text );
}

sub send_command {
    my($self, $command) = @_;
    $self->send_htv2_command( HTV2_CMD_HD44780_CMD, $command );
}

sub send_htv2_command {
    my($self, $command, @params ) = @_;
    if( $self->devicetype eq 'serialrx') {
        my $buffer  = chr($command);
        if( $command == HTV2_CMD_PRINT ) {
            # one param - a text string
            $buffer .= $params[0];
        } else {
            # all other cases - params are ASCII char codes
            for my $p ( @params ) {
                $buffer .= chr($p);
            }
        }
        return $self->systemdevice->write( $buffer . HTV2_END_SERIALRX_COMMAND );
    } else {
        my @i2cvals  = ( $command );
        if( $command == HTV2_CMD_PRINT ) {
            # one param - a text string
            my @strvals = split(//, $params[0]);
            for my $p ( @strvals ) {
                push @i2cvals, ord($p);
            }
        } else {
            # all other cases - params are ASCII char codes
            push(@i2cvals, @params) if @params;

        }
        return $self->systemdevice->write( @i2cvals );
    }
}

sub backlight {
    my($self, $brightness) = @_;
    $brightness = 0 if $brightness < 0;
    $brightness = 100 if $brightness > 100;
    
    # $brightness = 0 to 100
    # we translate to 0 - 250
    
    return unless $self->backlightcontrol;
    my $bset;
    if($brightness < 0) {
        $bset = 0;
    } elsif( $brightness >= 250 ) {
        $bset = 250;
    } else {
        $bset = int( 2.5 * $brightness);
    }
    
    $self->send_htv2_command( HTV2_CMD_BACKLIGHT, $bset );
}

sub update_baudrate {
    my $self = shift;
    return unless $self->devicetype eq 'serialrx';
    my $baud = $self->systemdevice->baudrate;
    my $bflag;
    given( $baud ) {
        when( [ 2400 ] ) {
            $bflag = HTV2_BAUD_2400;
        }
        when( [ 4800 ] ) {
            $bflag = HTV2_BAUD_4800;
        }
        when( [ 9600 ] ) {
            $bflag = HTV2_BAUD_9600;
        }
        when( [ 14400 ] ) {
            $bflag = HTV2_BAUD_14400;
        }
        when( [ 19200 ] ) {
            $bflag = HTV2_BAUD_19200;
        }
        when( [ 28800 ] ) {
            $bflag = HTV2_BAUD_28800;
        }
        when( [ 57600 ] ) {
            $bflag = HTV2_BAUD_57600;
        }
        when( [ 115200 ] ) {
            $bflag = HTV2_BAUD_115200;
        }
        default {
            croak(qq(The baudrate of the serial device is not supported by the LCD controller));
        }
    }
    
    $self->send_htv2_command( HTV2_CMD_BAUD_RATE, $bflag );
    carp('The HTBackpackV2 device must be powered off and on after changing baudrate.');
}

sub update_geometry {
    my $self = shift;
    $self->send_htv2_command( HTV2_CMD_LCD_TYPE, $self->lines, $self->width );
}

sub change_i2c_address {
    my( $self, $newaddress) = @_;
    if( $self->devicetype eq 'serialrx') {
        carp('The HTBackpackV2 device is in Serial RX mode. You cannot change the i2c address.');
        return;
    }
    if($newaddress < 1 || $newaddress > 127) {
        croak('The i2c address must be in the range 1 - 127 ( 0x01 - 0x7F )');
    }
    $self->send_htv2_command( HTV2_CMD_I2C_ADDRESS, $newaddress );
    carp('The HTBackpackV2 device must be powered off and on after changing i2c address.');
}


#########################################################

package HiPi::Control::LCD::HTBackpackV2::I2C;

#########################################################

use strict;
use warnings;
use HiPi::Device;
use base qw( HiPi::Device );
use Fcntl;

__PACKAGE__->create_accessors( qw( devicename address ) );

use constant {
    I2C_SLAVE       => 0x0703,
};

sub new {
    my($class, $params) = @_;
    my $self = $class->SUPER::new($params);
    return $self;
}

sub write {
    my ($self, @vals) = @_;
    my $fh = IO::File->new($self->devicename, O_RDWR, 0);
    binmode($fh);
    my $buffer = join('', @vals);
    ioctl($fh, I2C_SLAVE, $self->address + 0 );
    print $fh chr($_) for ( @vals );
    $fh->flush;
    close($fh);
}

sub close { 1; }

1;
