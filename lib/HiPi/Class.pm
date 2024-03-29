#########################################################################################
# Package       HiPi::Class
# Description:  base class
# Created       Sat Nov 24 15:51:05 2012
# SVN Id        $Id: Class.pm 1718 2013-03-27 00:39:56Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::Class;

#########################################################################################

use strict;
use warnings;
use parent qw( Exporter );

our $VERSION = '0.20';

#-------------------------------------------------------------------
# Object Constructor
#-------------------------------------------------------------------

sub new {
    my ( $class, %params ) = @_;
    my $self = bless {'__hipi_instance_data' => {} }, $class;
    return $self->init_hipi_object( %params );
}

#-------------------------------------------------------------------
# We can also inherit as a mixin.
# Note that internally datanames are always lower case so we
# can have accessors styled GetSomeThing and SetSomeThing but
# these will point to a data member named 'something'.
# We could create all of the accessors below and these would
# all point at $obj->{__hipi_instance_data}->{'something'}
#
# GetSomeThing()
# SetSomeThing($val)
# get_something()
# set_something($val)
# something()
# something($val)
# SomeThing()
# SomeThing($val)
#-------------------------------------------------------------------

sub init_hipi_object {
    my ($self, %params) = @_;
    foreach my $key (sort keys( %params ) ) {
        my $dataname = lc($key);
        $self->{__hipi_instance_data}->{$dataname} = $params{$key};
    }
    return $self;
}

#-------------------------------------------------------------------
# Accessors
#-------------------------------------------------------------------

sub create_accessors { shift->create_dual_accessors( @_ ); }

#-----------------------------------
# create_get_accessors
#   get_method()
#-----------------------------------

sub create_get_accessors {
    no strict 'refs';
    my $package = shift;
    foreach my $method ( @_ ) {
        my $lcmethod = lc($method);
        my $getmethod = ( $lcmethod eq $method ) ? qq(get_${method}) : qq(Get${method});
        *{"${package}::${getmethod}"} = sub {
            return $_[0]->{__hipi_instance_data}->{$lcmethod};
        };
    }
}

#-----------------------------------
# create_set_accessors
#   set_method($val)
#-----------------------------------

sub create_set_accessors {
    no strict 'refs';
    my $package = shift;
    foreach my $method ( @_ ) {
        my $lcmethod = lc($method);
        my $setmethod = ( $lcmethod eq $method ) ? qq(set_${method}) : qq(Set${method});
        *{"${package}::${setmethod}"} = sub {
            return $_[0]->{__hipi_instance_data}->{$lcmethod} = $_[1];
        };
    }
}

#-----------------------------------
# create_both_accessors
#   get_method()
#   set_method($val)
#-----------------------------------

sub create_both_accessors {
    my ($package, @args) = @_;
    $package->create_get_accessors( @args );
    $package->create_set_accessors( @args );
}

#-----------------------------------
# create_dual_accessors
#   method()
#   method($val)
#-----------------------------------

sub create_dual_accessors {
    no strict 'refs';
    my $package = shift;
    foreach my $method ( @_ ) {
        my $lcmethod = lc($method);
        *{"${package}::${method}"} = sub {
            return $_[0]->{__hipi_instance_data}->{$lcmethod} = $_[1] if @_ == 2;
            return $_[0]->{__hipi_instance_data}->{$lcmethod};
        };
    }
}

#-----------------------------------
# create_ro_accessors
#   method()
#-----------------------------------

sub create_ro_accessors {
    no strict 'refs';
    my $package = shift;
    foreach my $method ( @_ ) {
        my $lcmethod = lc($method);
        *{"${package}::${method}"} = sub {
            return $_[0]->{__hipi_instance_data}->{$lcmethod};
        };
    }
}

#-----------------------------------
# create_asym_accessors
#   IsEnabled()
#   Enable($val)
#-----------------------------------

sub create_asym_accessors {
    no strict 'refs';
    my $package = shift;
    foreach my $method ( @_ ) {
        my $dataname = lc($method->{read});
        my $readmethod = $method->{read};
        *{"${package}::${readmethod}"} = sub {
            return $_[0]->{__hipi_instance_data}->{$dataname};
        };
        if( my $writemethod = $method->{write} ) {
            *{"${package}::${writemethod}"} = sub {
                 return $_[0]->{__hipi_instance_data}->{$dataname} = $_[1];
            };
        }
    }
}

#------------------------------------
# Some naughty procs to access by val
# name as we allow data without
# accessors in $obj initialisation.
# This removes the temptation to
# do $obj->{data}->{$name} and adds
# some name checking at least if we
# really must do this.
#------------------------------------

sub get_hipi_object_data {
    my($self, $valname) = @_;
    my $dataname = lc($valname);
    if(exists($self->{__hipi_instance_data}->{$dataname})) {
        return $self->{__hipi_instance_data}->{$dataname};
    } else {
        die qq(There is no class data member named $valname);   
    }
}

sub set_hipi_object_data {
    my($self, $valname, $val) = @_;
    my $dataname = lc($valname);
    if(exists($self->{__hipi_instance_data}->{$dataname})) {
        return $self->{__hipi_instance_data}->{$dataname} = $val;
    } else {
        die qq(There is no class data member named $valname);   
    }
}

1;

__END__
