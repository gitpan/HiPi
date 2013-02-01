#!perl

# SVN Id $Id: 00-load.t 427 2013-01-30 01:15:53Z Mark Dootson $

use Test::More tests => 4;

BEGIN {
	use_ok( 'HiPi' );
	use_ok( 'HiPi::Wiring' );
	use_ok( 'HiPi::BCM2835' );
}

use HiPi;
use HiPi::Wiring;
use HiPi::cpuinfo;
use HiPi::BCM2835;

{
	my $fixedrev = (exists($ENV{HIPI_FORCE_BOARD_REVISION})) ? $ENV{HIPI_FORCE_BOARD_REVISION} : HiPi::Wiring::piBoardRev();
	is( HiPi::cpuinfo::get_cpuinfo->{'Raspberry Pi Revision'}, $fixedrev, 'Raspberry Pi Board Revision');
}

1;
