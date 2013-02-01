#########################################################################################
# Package       HiPi::cpuinfo
# Description:  Data from /proc/cpuinfo
# Created       Sat Nov 24 00:30:35 2012
# SVN Id        $Id: cpuinfo.pm 446 2013-02-01 02:55:27Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

package HiPi::cpuinfo;

#########################################################################################

=head1 NAME

HiPi::cpuinfo

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

    use HiPi::cpuinfo;
    
    my $rpiboardrev = HiPi::cpuinfo::get_piboard_rev();
    
    my $infohashref = HiPi::cpuinfo::get_cpuinfo();
    

=head1 DESCRIPTION

Access the information in /proc/cpuinfo.

=head1 METHODS

=head2 get_piboard_rev()

    Returns the board revision ( 1 or 2 )

=head2 get_cpuinfo()

    Returns a has reference derived from the content of /proc/cpuinfo
    
    An example hash returned from a rev 2 board with 512mb
    
    'Raspberry Pi Revision' => '2'
    'Processor'             => 'ARMv6-compatible processor rev 7 (v6l)'
    'BogoMIPS'              => '697.95'
    'Features'              => 'swp half thumb fastmult vfp edsp java tls'
    'CPU implementer'       => '0x41'
    'CPU architecture'      => '7'
    'CPU variant'           => '0x0'
    'CPU part'              => '0xb76'
    'CPU revision'          => '7'
    'Hardware'              => 'BCM2708'
    'Revision'              => '000f'
    'Serial'                => '00000000ec4805c2'


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
use threads;
use threads::shared;

our %_cpuinfostash: shared;
    
{
    lock %_cpuinfostash;
    %_cpuinfostash = ( 'Raspberry Pi Revision' => 2 );
    
    unless($ENV{DEV_NONE_RASPBERRY_PLATFORM}){
        # Only do this on real raspi
        my $output = qx(cat /proc/cpuinfo);
        if( $output ) {
            for ( split(/\n/, $output) ) {
                if( $_ =~ /^([^\s])+\s*:\s(.+)$/ ) {
                    $_cpuinfostash{$1} = $2;
                }
            }
        }
    }
    
    if(exists($_cpuinfostash{Revision})) {
        if($_cpuinfostash{$1}{Revision} =~ /(2|3)$/ ) {
            $_cpuinfostash{$1}{'Raspberry Pi Revision'} = 1,
        }
    }
}

sub get_cpuinfo {
    # return a ref to the hash of values from /proc/cpuinfo.
    # %_cpuinfo is shared (threads::shared) data
    my %cpuinfo;
    {
        lock %_cpuinfostash;
        %cpuinfo = %_cpuinfostash;
    }
    return \%cpuinfo;
}

sub get_piboard_rev {
    my $rev;
    {
        lock %_cpuinfostash;
        $rev = $_cpuinfostash{'Raspberry Pi Revision'}
    }
    return $rev;
}

1;
