use 5.006;
use strict;
use warnings;

package File::ShareDir2::Resolver::Perl;

# ABSTRACT: ShareDir 1.0 @INC resolver

our $VERSION = '0.001000';

# AUTHORITY

use Carp qw( croak );
require File::ShareDir2::Resolver;
our @ISA = ('File::ShareDir2::Resolver');

sub dist_dir {
	my ( $self, $distname ) = @_;
	require File::Spec;
	my $path = File::Spec->catdir( 'auto', 'share', 'dist', $distname );

	# Find the full dir withing @INC
	foreach my $inc (@INC) {
		next unless defined $inc and !ref $inc;
		my $dir = File::Spec->catdir( $inc, $path );
		unless ( -d $dir ) {
			next;
		}

		unless ( -r $dir ) {
			croak("Found directory '$dir', but no read permissions");
		}
		return $dir;
	}
	return;
}

sub module_dir {
	my ( $self, $module ) = @_;
	require File::Spec;
	my $module_path = $module;
	$module_path =~ s/::/-/g;
	my $path = File::Spec->catdir( 'auto', 'share', 'module', $module_path );

	# Find the full dir withing @INC
	foreach my $inc (@INC) {
		next unless defined $inc and !ref $inc;
		my $dir = File::Spec->catdir( $inc, $path );
		unless ( -d $dir ) {
			next;
		}
		unless ( -r $dir ) {
			croak("Found directory '$dir', but no read permissions");
		}
		return $dir;
	}
	return;
}

1;

