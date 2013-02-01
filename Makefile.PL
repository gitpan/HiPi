#########################################################################################
# Description:  Makefile.PL for HiPi - High level wrappers for RaspberryPi GPIO
# Created       Fri Nov 23 11:12:59 2012
# svn id        $Id: Makefile.PL 439 2013-01-30 04:09:14Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 2 of the License, or any later 
#               version.
#########################################################################################

use ExtUtils::MakeMaker 6.46;

WriteMakefile(
    NAME           => 'HiPi',
    VERSION_FROM   => 'lib/HiPi.pm',
    AUTHOR         => 'Mark Dootson <mdootson@cpan.org>',
    ABSTRACT       => 'Hi level interface to Raspberry Pi GPIO',
    LICENSE        => 'GPL v3',
    MIN_PERL_VERSION => '5.12.0',
    PREREQ_PM      => { 'threads'          => 0,
                        'threads::shared'  => 0,
                        'Thread::Queue'    => 0,
                        'Try::Tiny'        => 0,
                        'Device::SerialPort' => 0,
                      },
    BUILD_REQUIRES => {  'Test::More' => 0 },
);

1;
