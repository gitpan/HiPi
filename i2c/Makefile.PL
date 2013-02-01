#########################################################################################
# Description:  Makefile.PL for HiPi::Wiring - wrappers for libwiringpi
# Created       Fri Nov 23 11:12:59 2012
# svn id        $Id: Makefile.PL 424 2013-01-09 00:11:11Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

use ExtUtils::MakeMaker 6.46;

WriteMakefile(
    NAME           => 'HiPi::Device::I2C',
    VERSION_FROM   => '../lib/HiPi/Device/I2C.pm',
    AUTHOR         => 'Mark Dootson <mdootson@cpan.org>',
    ABSTRACT       => 'Hi level I2C interface',
    LICENSE        => 'GPL v3',
    MIN_PERL_VERSION => '5.12.0',
    BUILD_REQUIRES => {  'Test::More' => 0 },
);

1;
