use 5.006;    # our
use strict;
use warnings;

package File::ShareDir2::Resolver::Perl::Legacy;

# ABSTRACT: The Pre-1.0 resolver mechanic

our $VERSION = '0.001000';

# AUTHORITY

use Carp qw( croak );
require File::ShareDir2::Resolver;
our @ISA = ('File::ShareDir2::Resolver');
use constant IS_MACOS => !!( $^O eq 'MacOS' );

sub dist_dir {
	my ( $self, $distname ) = @_;

	# Create the subpath
	my $path = File::Spec->catdir( 'auto', split( /-/, $distname ), );

	# Find the full dir within @INC
	foreach my $inc (@INC) {
		next unless defined $inc and !ref $inc;
		my $dir = File::Spec->catdir( $inc, $path );
		next unless -d $dir;
		unless ( -r $dir ) {
			Carp::croak("Found directory '$dir', but no read permissions");
		}
		return $dir;
	}
	return;
}

sub dist_file {
	my ( $self, $distname, $filename ) = @_;

	# Create the subpath
	my $path = File::Spec->catfile( 'auto', split( /-/, $distname ), $filename, );

	# Find the full dir withing @INC
	foreach my $inc (@INC) {
		next unless defined $inc and !ref $inc;
		my $full = File::Spec->catdir( $inc, $path );
		next unless -e $full;
		unless ( -r $full ) {
			Carp::croak("Directory '$full', no read permissions");
		}
		return $full;
	}
	return;
}

sub module_dir {
	my ( $self, $module ) = @_;
	require Class::Inspector;
	my $short = Class::Inspector->filename($module);
	my $long  = Class::Inspector->loaded_filename($module);
	$short =~ tr{/}{:} if IS_MACOS;
	substr( $short, -3, 3, '' );
	$long =~ m/^(.*)\Q$short\E\.pm\z/s or die("Failed to find base dir");
	my $dir = File::Spec->catdir( "$1", 'auto', $short );

	unless ( -d $dir ) {
		Carp::croak("Directory '$dir', does not exist");
	}
	unless ( -r $dir ) {
		Carp::croak("Directory '$dir', no read permissions");
	}
	return $dir;
}

1;

