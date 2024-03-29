#!perl

# SVN Id $Id: 005-basic.t 1028 2013-03-11 16:04:27Z Mark Dootson $

use Test::More tests => 2;

use HiPi::Wiring;
use HiPi::RaspberryPi;
use HiPi::Utils;

{
    my $fixedrev = (exists($ENV{HIPI_FORCE_BOARD_REVISION})) ? $ENV{HIPI_FORCE_BOARD_REVISION} : HiPi::Wiring::piBoardRev();
    is( HiPi::RaspberryPi::get_cpuinfo->{'GPIO Revision'}, $fixedrev, 'GPIO Revision');
    ok( defined(&HiPi::Utils::drop_permissions_id), 'HiPi Utils XS Loaded' );
}

1;
