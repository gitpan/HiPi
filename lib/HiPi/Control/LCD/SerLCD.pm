#########################################################################################
# Package       HiPi::Control::LCD::SerLCD
# Description:  SerLCD RX Enabled LCD Controller
# Created       Sat Nov 24 20:48:42 2012
# SVN Id        $Id: SerLCD.pm 451 2013-02-01 19:44:12Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Control::LCD::SerLCD;

#########################################################################################

=head1 NAME

HiPi::Control::LCD::SerLCD

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :raspberry :pinmode :serial
        :spi :i2c :wiring :bcm2835 :mcp23017 :htv2cmd
        :htv2baudrate );
    
    use HiPi::Control::LCD qw( :cursor :hd44780 );
    use HiPi::Control::LCD::SerLCD;
    
    my $hp = HiPi::Control::LCD::SerLCD->new(
        { width => 16, lines => 2, backlightcontrol => 1, devicetype => 'serialrx' } );
    
    $hp->enable(1);
		
    $hp->backlight(25);
    $hp->clear;

    $hp->set_cursor_position(0,0);
    $hp->send_text('Raspberry Pi');

    $hp->set_cursor_position(0,1);
    $hp->send_text('SerLCD');


=head1 DESCRIPTION

This module inherits from HiPi::Control::LCD to provide access to 
the SparkFun Electronics SerLCD ( serialRX) LCD interface.

=head1 METHODS

Common methods used by all HiPi::Control::LCD::xx classes can be found in the
HiPi::Control::LCD pod.

HiPi::Control::LCD::SerLCD specific methods are

=head2 toggle_splashscreen

    $lcd->toggle_splashscreen();

Toggles splash screen display on / off

=head2 set_splashscreen

    $lcd->set_splashscreen();

Sets the current top 2 lines of text as the splash screen.

=head2 init_lcd

    $lcd->init_lcd();
    
If the SerLCD gets into an unknown state, call this to reset the LCD to default settings.


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

our $VERSION = '0.01';

use constant {
    SLCD_START_COMMAND    => chr(0xFE),
    SLCD_SPECIAL_COMMAND  => chr(0x7C),
};

sub new {
    my ($class, $userparams) = @_;
    
    my %params = (
        # standard device
        devicename      => '/dev/ttyAMA0',
        
        # serial port
        baudrate        => 9600,
        parity          => 'none',
        stopbits        => 1,
        databits        => 8,
        
        # LCD
        width            =>  undef,
        lines            =>  undef,
        backlightcontrol =>  0,
        systemdevice     =>  undef,
        positionmap      =>  undef,
    );
    
    # get user params
    foreach my $key( keys (%$userparams) ) {
        $params{$key} = $userparams->{$key};
    }
    
    unless( defined($params{systemdevice}) ) {
        my %portparams;
        for (qw( devicename baudrate parity stopbits databits ) ) {
            $portparams{$_} = $params{$_};
        }
        require HiPi::Device::SerialPort;
        $params{systemdevice} = HiPi::Device::SerialPort->new(\%portparams);
    }
    
    my $self = $class->SUPER::new(\%params);
    return $self;
}

sub send_text {
    my($self, $text) = @_;
    $self->systemdevice->write( $text );
}

sub send_command {
    my($self, $command) = @_;
    $self->systemdevice->write( SLCD_START_COMMAND . chr($command) );
}

sub send_special_command {
    my($self, $command) = @_;
    $self->systemdevice->write( SLCD_SPECIAL_COMMAND . chr($command) );
}

sub backlight {
    my($self, $brightness) = @_;
    $brightness = 0 if $brightness < 0;
    $brightness = 100 if $brightness > 100;
    
    # input $brightness = 0 to 100
    #
    # SerLCD uses a 30 range value 128 - 157
    # to control brightness level
    
    return unless ($self->backlightcontrol);

    my $level;
    if( $brightness == 0 ) {
        $level = 128;
    } elsif( $brightness == 1 ) {
        $level = 129;
    } elsif( $brightness == 100 ) {
        $level = 157;
    } else {
        $level = int( 128.5 + ( ( $brightness / 100 ) * 30 ) );
        $level = 129 if $level < 129;
    }
    
    $level = 157 if $level > 157;
    
    $self->send_special_command( $level );
}

sub update_baudrate {
    my $self = shift;
    my $baud = $self->systemdevice->baudrate;
    my $bflag;
    given( $baud ) {
        when( [ 2400 ] ) {
            $bflag = 11;
        }
        when( [ 4800 ] ) {
            $bflag = 12;
        }
        when( [ 9600 ] ) {
            $bflag = 13;
        }
        when( [ 14400 ] ) {
            $bflag = 14;
        }
        when( [ 19200 ] ) {
            $bflag = 15;
        }
        when( [ 38400 ] ) {
            $bflag = 16;
        }
        default {
            croak(qq(The baudrate of the serial device is not supported by the LCD controller));
        }
    }
    
    $self->send_special_command( $bflag );
}

sub update_geometry {
    my $self = shift;
    
    if($self->width == 20) {
        $self->send_special_command( 3 );
    }
    if($self->width == 16) {
        $self->send_special_command( 4 );
    }
    if($self->lines == 4) {
        $self->send_special_command( 5 );
    }
    if($self->lines == 2) {
        $self->send_special_command( 6 );
    }
    if($self->lines == 1) {
        $self->send_special_command( 7 );
    }
}

sub enable_backlight {
    my($self, $flag) = @_;
    $flag = 1 if !defined($flag);
    if( $flag ) {
        $self->send_special_command( 1 );
    } else {
        $self->send_special_command( 2 );
    }
}

sub toggle_splashscreen {
    $_[0]->send_special_command( 9 );
}

sub init_lcd {
    $_[0]->send_special_command( 8 );
}

sub set_splashscreen {
    $_[0]->send_special_command( 10 );
}

1;
