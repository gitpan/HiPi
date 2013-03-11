use 5.14.0;
use strict;

use lib 'inc';
require Module::Build::HiPi;

our $VERSION = '0.20';

my $build = Module::Build::HiPi->new(
	module_name        => 'HiPi',
	license            => 'gpl',
	dist_author        => q{Mark Dootson <mdootson@cpan.org>},
	dist_version_from  => 'lib/HiPi.pm',
	configure_requires => {
            'perl'          => '5.14.0',
	    'Module::Build' => '0',
	},
	add_to_cleanup => [
            '*.o',
            'blib',
            '*.a',
            '*.so',
            '*.c',
            '*.xsc',
            '*.bs',
            '*.mksf',
	],
	meta_merge => {
            resources => {
                homepage   => 'http://raspberry.znix.com/',
            },
            no_index => {
                directory => [qw<inc mylib BCM2835 Wiring suidbin userbin>],
            },
	},
	dist_abstract   => 'Raspberry Pi GPIO Modules',
        
        get_options     => {
            'hipi-wx'         => { type => '!', default => 1, },
        },

);


{ # Get Options
    my($doupdate, $doupgrade, $dowx, $dowiring) = ( 0,0,0,0 );
    
    # Leave it to user to do update and upgrade
    
    #if(defined($build->args('hipi-update'))) {
    #    $doupdate = _hipi_option_is_yes($build->args('hipi-update'));
    #} else {
    #    $doupdate = $build->y_n('Perform apt-get update before installing dependencies? (recommended)', 'yes');
    #}
    
    #if($doupdate) {
    #    if(defined($build->args('hipi-upgrade'))) {
    #        $doupgrade = _hipi_option_is_yes($build->args('hipi-upgrade'));
    #    } else {
    #        $doupgrade = $build->y_n('Perform apt-get upgrade before installing dependencies? (recommended)', 'yes');
    #    }
    #} else {
    #    $doupgrade = 0;
    #}
    
    if(defined($build->args('hipi-wx'))) {
        $dowx = _hipi_option_is_yes($build->args('hipi-wx'));
    } else {
        $dowx = $build->y_n('Install custom wxPerl GUI dependencies? (required for GUI modules and scripts)', 'yes');
    }
    
    $build->notes( doupdate     => $doupdate );
    $build->notes( doupgrade    => $doupgrade );
    $build->notes( dowx         => $dowx );

}

$build->create_build_script();

sub _hipi_option_is_yes {
    return lc( $_[0] ) eq 'y' || lc( $_[0] ) eq 'yes' || $_[0] eq 1;
}

