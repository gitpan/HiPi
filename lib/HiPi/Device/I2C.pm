#########################################################################################
# Package       HiPi::Device::I2C
# Description:  Wrapper for I2C communucation
# Created       Fri Nov 23 13:55:49 2012
# SVN Id        $Id: I2C.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Device::I2C;

#########################################################################################

=head1 NAME

HiPi::Device::I2C

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::Device::I2C qw( ioctl );
    
    my $i2c = HiPi::Device::I2C->new('/dev/i2c-1');
    
    $i2c->select_address( 0x20 );
    
    $i2c->smbus_write($regadress, @bytes);
    
    my @bytes = $i2c->smbus_read($regadress, $numbytes);
    

=head1 DESCRIPTION

Experimental interface to I2C. Currently used by HiPi::MCP23017 and HiPi::Control::LCD::HTBackpackV2 in i2c mode.

=head1 METHODS

=head2 new

    $i2c = HiPi::Device::I2C->new('/dev/i2c-1');

Pass the i2c device name to the constructor

=head2 select_address

    $i2c->select_address( $address );

Pass the address of the i2c device you wish to control. For example, the default address of the popular MCP23017 device is 0x20

    $i2c->select_address( 0x20 );

=head2 smbus_write

    $i2c->smbus_write( @vals );

Use smbus interface to write data.

If scalar @vals == 1 then calls i2c_smbus_write_byte( file, $vals[0])

If scalar @vals == 2 then calls i2c_smbus_write_byte_data( file, $vals[0], $vals[1])

Else calls i2c_smbus_write_i2c_block_data(file, $vals[0], \@vals[1 ..-1])

=head2 smbus_read

    my @vals $i2c->smbus_read( $cmdval, $numbytes );

Use smbus interface to read data.

If $cmdval is not defined then calls i2c_smbus_read_byte( file )

If $numbytes <= 1 then calls i2c_smbus_read_byte_data( file, $cmdval)

Else calls i2c_smbus_read_ic2_block_data(file, $cmdval, $numbytes)

    
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
use IO::File;
use Fcntl;
use XSLoader;
use Carp;
use Time::HiRes qw( usleep );
use HiPi::GPIO::PAD1;

our $VERSION = '0.01';

__PACKAGE__->create_accessors( qw ( fh fno i2c_address ) );

unless($ENV{DEV_NONE_RASPBERRY_PLATFORM}) {
    # on some other platform
    XSLoader::load('HiPi::Device::I2C', $VERSION);
}

our @EXPORT_OK = ();
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

sub _register_exported_constants {
    my( $tag, @constants ) = @_;
    $EXPORT_TAGS{$tag} = \@constants;
    push( @EXPORT_OK, @constants);
}

use constant {
    I2C_RETRIES     => 0x0701, 
    I2C_TIMEOUT     => 0x0702,
    I2C_SLAVE       => 0x0703,
    I2C_TENBIT      => 0x0704,
    I2C_FUNCS       => 0x0705,
    I2C_SLAVE_FORCE => 0x0706,
    I2C_RDWR        => 0x0707,
    I2C_PEC         => 0x0708,
    I2C_SMBUS       => 0x0720,
};

_register_exported_constants qw(
    ioctl
    I2C_RETRIES
    I2C_TIMEOUT
    I2C_SLAVE
    I2C_SLAVE_FORCE
    I2C_TENBIT
    I2C_FUNCS
    I2C_RDWR
    I2C_PEC
    I2C_SMBUS
);



sub new {
    my( $class, $devicename ) = @_;
    
    my $fh = IO::File->new( $devicename, O_RDWR, 0 ) or croak qq(open error on $devicename: $!\n);
    my $self = $class->SUPER::new({
        fh          => $fh,
        fno         => $fh->fileno(),
        i2c_address => 0,
    });
    
    # Ensure IO Pins are correctly set
    my $pad = HiPi::GPIO::PAD1->new;
    $pad->prepare_I2C0;
    return $self;
}

sub DESTROY { $_[0]->close; }

sub close {
    my $self = shift;
    if( $self->fh ) {
        $self->fh->flush;
        $self->fh->close;
        $self->fh( undef );
        $self->fno( undef );
        $self->i2c_address( undef );
    }
}

sub select_address {
    my ($self, $address) = @_;
    if( $address != $self->i2c_address ) {
        if( $self->ioctl( I2C_SLAVE, $address + 0 ) ) {
           $self->i2c_address( $address );
        } else {
            croak(qq(Failed to activate address $address : $!));
        }
    }
    $self->i2c_address();
}

sub ioctl {
    my ($self, $ioctlconst, $data) = @_;
    _post_delay( $self->fh->ioctl( $ioctlconst, $data ) );
}

sub _post_delay {
    usleep( 10 );
    return @_;
}

sub i2c_write {
    croak('Not yet supported');
}

sub i2c_read {
    croak('Not yet supported');
}

sub smbus_write {
    my ($self, @bytes) = @_;
    if( @bytes == 1) {
        $self->smbus_write_byte($bytes[0]);
    } elsif( @bytes == 2) {
        $self->smbus_write_byte_data( @bytes );
    } else {
        my $command = shift @bytes;
        $self->smbus_write_i2c_block_data($command, \@bytes );
    }
}

sub smbus_read {
    my ($self, $cmdval, $numbytes) = @_;
    if(!defined($cmdval)) {
        return $self->smbus_read_byte;
    } elsif(!$numbytes || $numbytes <= 1 ) {
        return $self->smbus_read_byte_data( $cmdval );
    } else {
        return $self->smbus_read_i2c_block_data($cmdval, $numbytes );
    }
}

sub smbus_write_quick {
    _post_delay(i2c_smbus_write_quick($_[0]->fno, $_[1]));
}

sub smbus_read_byte {
    _post_delay(i2c_smbus_read_byte( $_[0]->fno ));
}

sub smbus_write_byte {
    _post_delay(i2c_smbus_write_byte($_[0]->fno, $_[1]));
}

sub smbus_read_byte_data {
    _post_delay(i2c_smbus_read_byte_data($_[0]->fno, $_[1]));
}

sub smbus_write_byte_data {
    _post_delay(i2c_smbus_write_byte_data($_[0]->fno, $_[1], $_[2]));
}

sub smbus_read_word_data {
    _post_delay(i2c_smbus_read_word_data($_[0]->fno, $_[1]));
}

sub smbus_write_word_data {
    _post_delay(i2c_smbus_write_word_data($_[0]->fno, $_[1], $_[2]));
}

sub smbus_read_word_swapped {
    _post_delay(i2c_smbus_read_word_swapped($_[0]->fno, $_[1]));
}

sub smbus_write_word_swapped {
    _post_delay(i2c_smbus_write_word_swapped($_[0]->fno, $_[1], $_[2]));
}

sub smbus_process_call {
    _post_delay(i2c_smbus_process_call($_[0]->fno, $_[1], $_[2]));
}

sub smbus_read_block_data {
    _post_delay(i2c_smbus_read_block_data($_[0]->fno, $_[1]));
}

sub smbus_read_ic2_block_data {
    _post_delay(i2c_smbus_read_ic2_block_data($_[0]->fno, $_[1], $_[2]));
}

sub smbus_write_block_data {
    _post_delay(i2c_smbus_write_block_data($_[0]->fno, $_[1], $_[2]));
}

sub smbus_write_i2c_block_data {
    _post_delay(i2c_smbus_write_i2c_block_data($_[0]->fno, $_[1], $_[2]));
}

1;
