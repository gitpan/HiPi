#########################################################################################
# Description:  Makefile.PL for HiPi::BCM2835 - High level wrappers for libbcm2835
# Created       Fri Nov 23 11:12:59 2012
# svn id        $Id: Makefile.PL 424 2013-01-09 00:11:11Z Mark Dootson $
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

# create libbcm2385
{
    # get gcc and ld to use
    my $gcc = $Config{cc};
    my $gxx = $gcc;
    $gxx =~ s/^gcc/g\+\+/;
    my $gld = $Config{ld};
    
    $buildlibdir = Cwd::abs_path( getcwd() );
    die 'Failed to determine working directory' unless $buildlibdir && $buildlibdir =~ /\/bcm2835$/;
    
    # fix permissions
    for (qw( src/configure buildextlib.sh) ){
        chmod(0777, qq($buildlibdir/$_) );
    }
    
    $buildlibdir .= '/buildlib';
    mkdir( $buildlibdir, 0777 );
    system(qq(rm -rf $buildlibdir/*)) and die qq(Failed to clear directory $buildlibdir );
    print qq(Creating libbcm2835 ... \n);
    system(qq(./buildextlib.sh $buildlibdir $gcc $gxx $gld)) and die qq(Failed to create libbcm2835);
}

WriteMakefile(
    NAME           => 'HiPi::BCM2835',
    VERSION_FROM   => '../lib/HiPi/BCM2835.pm',
    AUTHOR         => 'Mark Dootson <mdootson@cpan.org>',
    ABSTRACT       => 'Hi level interface to libbcm2835',
    LICENSE        => 'GPL v3',
    MIN_PERL_VERSION => '5.12.0',
    PREREQ_PM      => { 'threads'          => 0,
                        'threads::shared'  => 0,
                        'Thread::Queue'    => 0,
                      },
    BUILD_REQUIRES => {  'Test::More' => 0, 'Cwd' => 0 },
    NORECURS       => 1,
    INC            => '-I./src/bcm2835/src',
    LIBS           => ["-L$buildlibdir/src -lbcm2835 -lrt"],
);

1;
