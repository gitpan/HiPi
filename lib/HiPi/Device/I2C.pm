#########################################################################################
# Package       HiPi::Device::I2C
# Description:  Wrapper for I2C communucation
# Created       Fri Nov 23 13:55:49 2012
# SVN Id        $Id: I2C.pm 1044 2013-03-11 19:57:44Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Device::I2C;

#########################################################################################

use strict;
use warnings;
use HiPi;
use parent qw( HiPi::Device );
use IO::File;
use Fcntl;
use XSLoader;
use Carp;
use Time::HiRes qw( usleep );
use HiPi::Constant qw( :raspberry );
use Try::Tiny;
use HiPi::Utils qw( is_raspberry );

our $VERSION = '0.20';

__PACKAGE__->create_accessors( qw ( fh fno address ) );

XSLoader::load('HiPi::Device::I2C', $VERSION) if is_raspberry;

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
    I2C_DEFAULT_BAUD => 100000,
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
    I2C_DEFAULT_BAUD
);


our @_moduleinfo = (
    { name => 'i2c_bcm2708', params => { baudrate => 100000 }, },
    { name => 'i2c_dev',     params => {}, },
);


sub get_module_info {
    return @_moduleinfo;
}

{
    my $discard = __PACKAGE__->get_baudrate();
}

sub get_baudrate {
    my $class = shift;
    my $baudrate = HiPi::qx_sudo_shell('cat /sys/module/i2c_bcm2708/parameters/baudrate 2>&1');
    if($?) {
        return $_moduleinfo[0]->{params}->{baudrate};
    }
    chomp($baudrate);
    $_moduleinfo[0]->{params}->{baudrate} = $baudrate;
    return $baudrate;
}

sub set_baudrate {
    my ($class, $newrate) = @_;
    croak('Usage HiPi::Device::I2C->set_baudrate( $baudrate )') if ( defined($newrate) && ref($newrate) );
    $_moduleinfo[0]->{params}->{baudrate} = $newrate;
    $class->load_modules(1);
}

sub get_device_list {
    # get the devicelist
    opendir my $dh, '/dev' or croak qq(Failed to open dev : $!);
    my @i2cdevs = grep { $_ =~ /^i2c-\d+$/ } readdir $dh;
    closedir($dh);
    
    for (my $i = 0; $i < @i2cdevs; $i++) {
        $i2cdevs[$i] = '/dev/' . $i2cdevs[$i];
    }
    return @i2cdevs;
}

sub new {
    my ($class, %userparams) = @_;
    
    my %params = (
        devicename   => ( RPI_BOARD_REVISION == 1 ) ? '/dev/i2c-0' : '/dev/i2c-1',
        address      => 0,
        fh           => undef,
        fno          => undef,
    );
    
    foreach my $key (sort keys(%userparams)) {
        $params{$key} = $userparams{$key};
    }

    my $fh = IO::File->new( $params{devicename}, O_RDWR, 0 ) or croak qq(open error on $params{devicename}: $!\n);
    
    $params{fh}  = $fh;
    $params{fno} = $fh->fileno(),
    
    my $self = $class->SUPER::new(%params);
    
    # select address if id provided
    $self->_do_select_address( $self->address ) if $self->address;

    return $self;
}

sub close {
    my $self = shift;
    if( $self->fh ) {
        $self->fh->flush;
        $self->fh->close;
        $self->fh( undef );
        $self->fno( undef );
        $self->address( undef );
    }
}

sub select_address {
    my ($self, $address) = @_;
    if( $address != $self->address ) {
        $self->_do_select_address($address);
    }
    return $self->address;
}

sub _do_select_address {
    my ($self, $address) = @_;
    if( $self->ioctl( I2C_SLAVE, $address + 0 ) ) {
        $self->address( $address );
    } else {
        croak(qq(Failed to activate address $address : $!));
    }
}

sub ioctl {
    my ($self, $ioctlconst, $data) = @_;
    $self->fh->ioctl( $ioctlconst, $data );
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
    my($self, $command ) = @_;
    i2c_smbus_write_quick($self->fno, $command);
}

sub smbus_read_byte {
    my( $self ) = @_;
    i2c_smbus_read_byte( $self->fno );
}

sub smbus_write_byte {
    my($self, $command) = @_;
    i2c_smbus_write_byte($self->fno, $command);
}

sub smbus_read_byte_data {
    my($self, $command, $data) = @_;
    i2c_smbus_read_byte_data($self->fno, $command);
}

sub smbus_write_byte_data {
    my($self, $command, $data) = @_;
    i2c_smbus_write_byte_data($self->fno,  $command, $data);
}

sub smbus_read_word_data {
    my($self, $command) = @_;
    i2c_smbus_read_word_data($self->fno, $command);
}

sub smbus_write_word_data {
    my($self, $command, $data) = @_;
    i2c_smbus_write_word_data($self->fno, $command, $data);
}

sub smbus_read_word_swapped {
    my($self, $command) = @_;
    i2c_smbus_read_word_swapped($self->fno, $command);
}

sub smbus_write_word_swapped {
    my($self, $command, $data) = @_;
    i2c_smbus_write_word_swapped($self->fno, $command, $data);
}

sub smbus_process_call {
    my($self, $command, $data) = @_;
    i2c_smbus_process_call($self->fno, $command, $data);
}

sub smbus_read_block_data {
    my($self, $command) = @_;
    i2c_smbus_read_block_data($self->fno, $command);
}

sub smbus_read_i2c_block_data {
    my($self, $command, $data) = @_;
    i2c_smbus_read_i2c_block_data($self->fno, $command, $data);
}

sub smbus_write_block_data {
    my($self, $command, $data) = @_;
    i2c_smbus_write_block_data($self->fno, $command, $data);
}

sub smbus_write_i2c_block_data {
    my($self, $command, $data) = @_;
    i2c_smbus_write_i2c_block_data($self->fno, $command, $data);
}

1;

__END__
