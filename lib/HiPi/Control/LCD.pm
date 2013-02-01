#########################################################################################
# Package       HiPi::Control::LCD
# Description:  Control a LCD based on HD44780
# Created       Sat Nov 24 20:24:23 2012
# SVN Id        $Id: LCD.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Control::LCD;

#########################################################################################

=head1 NAME

HiPi::Control::LCD

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Constant qw( :raspberry :pinmode :serial
        :spi :i2c :wiring :bcm2835 :mcp23017 :htv2cmd
        :htv2baudrate );
    
    use HiPi::Control::LCD qw( :cursor :hd44780 );
    use HiPi::Control::LCD::SerLCD;
    
    my $hp = HiPi::Control::LCD::SerLCD->new( { width => 16, lines => 2, backlightcontrol => 1, devicetype => 'serialrx' } );
    $hp->enable(1);
		
    $hp->backlight(25);
    $hp->clear;

    $hp->set_cursor_position(0,0);
    $hp->send_text('Raspberry Pi');

    $hp->set_cursor_position(0,1);
    $hp->send_text('SerLCD Control');


=head1 DESCRIPTION

This module is a base class for a common interface to Hitachi HD44780 displays whether
driven by I2C interfaces, SerialRX interfaces or direct HD44780 access.

Modules are currently provided for:

SparkFun SerLCD serialRX interface
    HiPi::Control::LCD::SerLCD

HobbyTronics Version 2 Backpack (serialRX and I2C )
    HiPi::Control::LCD::HTBackpackV2

=head1 METHODS

Common methods used by all HiPi::Control::LCD::xx classes.

=head2 new

    my $lcd = HiPi::Control::LCD::SerLCD->new(
      { width => 16,
        lines => 2,
        backlightcontrol => 1,
        devicetype => 'serialrx' }
    );
    
    Width & lines provide the character dimensions of the display
    
    backlightcontrol sets whether the interface should be allowed to
    control the backlight levels. For some LCDs attempting to set
    the backlight level via a serlRX or I2C interface can damage
    the LCD. Set to 0 to disable backlight control
    
    devicetype - can be serialrx or i2c depending on what your
    hardware supports.


=head2 enable
    $lcd->enable($bool);

Switch the LCD on / off

=head2 set_cursor_position

    $lcd->set_cursor_position($column, $row);

Set the current cursor position. $lcd->set_cursor_position(0, 0) sets the position to the leftmost column of the top row.

=head2 move_cursor_left

    $lcd->move_cursor_left();

Shift the cursor position 1 to the left

=head2 move_cursor_right

    $lcd->move_cursor_right();

Shift the cursor position 1 to the right

=head2 home

    $lcd->home();

Move the cursor to top left

=head2 clear

    $lcd->clear();

Move the cursor to top left and clear all text

=head2 set_cursor_mode

    $lcd->set_cursor_mode($mode);

Set the cursor mode. Valid values for $mode are the module constants exported under tag ':cursor'

    SRX_CURSOR_OFF 
    SRX_CURSOR_BLINK 
    SRX_CURSOR_UNDERLINE

=head2 backlight

    $lcd->$backlight($percent);

Set the backlight light level. Valid values for $percent is a number between 0 and 100

=head2 send_text

    $lcd->send_text($textstring);

Send text to be 'printed' at the current cursor position.

=head2 send_command

    $lcd->send_command($command);

Send an HD44780 command. Valid values for $command are the module constants exported under tag ':hd44780'

    HD44780_CLEAR_DISPLAY 
    HD44780_HOME_UNSHIFT
    HD44780_CURSOR_MODE_LEFT
    HD44780_CURSOR_MODE_LEFT_SHIFT
    HD44780_CURSOR_MODE_RIGHT
    HD44780_CURSOR_MODE_RIGHT_SHIFT
    HD44780_DISPLAY_OFF
    HD44780_DISPLAY_ON
    HD44780_CURSOR_OFF
    HD44780_CURSOR_UNDERLINE
    HD44780_CURSOR_BLINK
    HD44780_SHIFT_CURSOR_LEFT
    HD44780_SHIFT_CURSOR_RIGHT
    HD44780_SHIFT_DISPLAY_LEFT
    HD44780_SHIFT_DISPLAY_RIGHT

=head2 update_baudrate

    $lcd->update_baudrate($baudrate);

Update the interface baudrate to the new value.

=head2 update_geometry

    $lcd->update_geometry();

Update the interface geometry with the 'width' and 'lines' values passed in the $lcd constructor.


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
use HiPi::Control;
use base qw( HiPi::Control );
use Carp;

__PACKAGE__->create_accessors( qw(
    width lines systemdevice backlightcontrol positionmap
    ) );

our @EXPORT = ();
our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

use constant {
    SRX_CURSOR_OFF       => 0x0C,
    SRX_CURSOR_BLINK     => 0x0F,
    SRX_CURSOR_UNDERLINE => 0x0E,
};

{
    my @const = qw( SRX_CURSOR_OFF SRX_CURSOR_BLINK SRX_CURSOR_UNDERLINE );
    push( @EXPORT_OK, @const );
    $EXPORT_TAGS{cursor} = \@const;
}

# HD44780 commands

use constant {
    HD44780_CLEAR_DISPLAY           => 0x01,
    HD44780_HOME_UNSHIFT            => 0x02,
    HD44780_CURSOR_MODE_LEFT        => 0x04,
    HD44780_CURSOR_MODE_LEFT_SHIFT  => 0x05,
    HD44780_CURSOR_MODE_RIGHT       => 0x06,
    HD44780_CURSOR_MODE_RIGHT_SHIFT => 0x07,
    HD44780_DISPLAY_OFF             => 0x08,
    
    HD44780_DISPLAY_ON              => 0x0C,
    HD44780_CURSOR_OFF              => 0x0C,
    HD44780_CURSOR_UNDERLINE        => 0x0E,
    HD44780_CURSOR_BLINK            => 0x0F,
    
    HD44780_SHIFT_CURSOR_LEFT       => 0x10,
    HD44780_SHIFT_CURSOR_RIGHT      => 0x14,
    HD44780_SHIFT_DISPLAY_LEFT      => 0x18,
    HD44780_SHIFT_DISPLAY_RIGHT     => 0x1C,
    
    HD44780_CURSOR_POSITION         => 0x80,
    
};

{
    my @const = qw(
        HD44780_CLEAR_DISPLAY 
        HD44780_HOME_UNSHIFT
        HD44780_CURSOR_MODE_LEFT
        HD44780_CURSOR_MODE_LEFT_SHIFT
        HD44780_CURSOR_MODE_RIGHT
        HD44780_CURSOR_MODE_RIGHT_SHIFT
        HD44780_DISPLAY_OFF
        
        HD44780_DISPLAY_ON
        HD44780_CURSOR_OFF
        HD44780_CURSOR_UNDERLINE
        HD44780_CURSOR_BLINK
        
        HD44780_SHIFT_CURSOR_LEFT
        HD44780_SHIFT_CURSOR_RIGHT
        HD44780_SHIFT_DISPLAY_LEFT
        HD44780_SHIFT_DISPLAY_RIGHT
        
        HD44780_CURSOR_POSITION
    );
    push( @EXPORT_OK, @const );
    $EXPORT_TAGS{hd44780} = \@const;
}

sub new {
    my ($class, $userparams ) = @_;
    
    my %params = (
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
    
    croak('A derived class must provide a system device') unless(defined($params{systemdevice}));
    
    unless( $params{positionmap} ) {   
        # setup default position map
        unless( $params{width} =~ /^(16|20)$/ && $params{lines} =~ /^(2|4)$/) {
            croak('HiPi::Control::LCD only supports default LCD types 16x2, 16x4, 20x2, 20x4' );
        }
        my (@pmap, @line1, @line2, @line3, @line4, @buffers);
        
        if( $params{width} == 16 ) {
            @line1 = (0..15);
            @line2 = (64..79);
            @line3 = (16..31);
            @line4 = (80..95);
        } elsif( $params{width} == 20 ) {
            @line1 = (0..19);
            @line2 = (64..83);
            @line3 = (20..39);
            @line4 = (84..103);
        }
        
        if( $params{lines} == 2 ) {
            @pmap = ( @line1, @line2 );
        } elsif( $params{lines} == 4 ) {
            @pmap = ( @line1, @line2, @line3, @line4 );
        }
        
        $params{positionmap} = \@pmap;
    }
    
    my $self = $class->SUPER::new(\%params);
    
    $self->update_geometry; # will set cols / lines to controller
    
    return $self;
}

sub enable {
    my($self, $enable) = @_;
    $enable = 1 unless defined($enable);
    my $command = ( $enable ) ? HD44780_DISPLAY_ON : HD44780_DISPLAY_OFF;
    $self->send_command( $command ) ;
}

sub set_cursor_position {
    my($self, $col, $row) = @_;
    my $pos = $col + ( $row * $self->width ); 
    $self->send_command( HD44780_CURSOR_POSITION + $self->positionmap->[$pos] );
}

sub move_cursor_left  {
    $_[0]->send_command( HD44780_SHIFT_CURSOR_LEFT );
}

sub move_cursor_right  {
    $_[0]->send_command( HD44780_SHIFT_CURSOR_RIGHT );
}

sub home  { $_[0]->send_command( HD44780_HOME_UNSHIFT ); }

sub clear { $_[0]->send_command( HD44780_CLEAR_DISPLAY ); }

sub set_cursor_mode { $_[0]->send_command( $_[1] ); }

sub backlight { croak('backlight must be overriden in derived class'); }

sub send_text { croak('send_text must be overriden in derived class'); }

sub send_command { croak('send_command must be overriden in derived class'); }

sub update_baudrate { croak('update_baudrate must be overriden in derived class'); }

sub update_geometry { croak('update_geometry must be overriden in derived class'); }


1;
