#########################################################################################
# Description:  Makefile.PL for HiPi::Wiring - wrappers for libwiringpi
# Created       Fri Nov 23 11:12:59 2012
# svn id        $Id: Makefile.PL 438 2013-01-30 03:17:11Z Mark Dootson $
# Copyright:    Copyright (c) 2012 Mark Dootson
# Licence:      This work is free software; you can redistribute it and/or modify it 
#               under the terms of the GNU General Public License as published by the 
#               Free Software Foundation; either version 3 of the License, or any later 
#               version.
#########################################################################################

use ExtUtils::MakeMaker 6.46;

use Config;
use Cwd;

my $buildlibdir;

# create libwiringPi
{
       
    $buildlibdir = Cwd::abs_path( getcwd() );
    die 'Failed to determine working directory' unless $buildlibdir && $buildlibdir =~ /\/wiring$/;
    
    $buildlibdir .= '/src/wiringPi';
    
    # fix permissions
    chmod(0777, qq(./buildextlib.sh) );
        
    print qq(Creating libwiringPi ... \n);
    system(qq(./buildextlib.sh)) and die qq(Failed to create libwiringPi);
}

WriteMakefile(
    NAME           => 'HiPi::Wiring',
    VERSION_FROM   => '../lib/HiPi/Wiring.pm',
    AUTHOR         => 'Mark Dootson <mdootson@cpan.org>',
    ABSTRACT       => 'Hi level interface to libwiringPi',
    LICENSE        => 'GPL v3',
    MIN_PERL_VERSION => '5.12.0',
    BUILD_REQUIRES => {  'Test::More' => 0 },
    LIBS           => ["-L$buildlibdir -lwiringPiStatic -lpthread"],
);

1;
