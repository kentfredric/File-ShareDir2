use 5.006;
use strict;
use warnings;

package File::ShareDir2::Resolver::Perl;

# ABSTRACT: ShareDir 1.0 @INC resolver

our $VERSION = '0.001000';

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

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
      File::ShareDir2::log_trace { "$self:dist_dir: $distname not in $inc" };
      next;
    }
    File::ShareDir2::log_trace { "$self:dist_dir: found $distname in $inc" };

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
	my $module_path = $module =~ s/::/-/g;
	my $path = File::Spec->catdir( 'auto', 'share', 'module', $module_path );

	# Find the full dir withing @INC
	foreach my $inc (@INC) {
		next unless defined $inc and !ref $inc;
		my $dir = File::Spec->catdir( $inc, $path );
    unless ( -d $dir ) {
      File::ShareDir2::log_trace { "$self:module_dir: $module not in $inc" };
      next;
    }
    File::ShareDir2::log_trace { "$self:module_dir: found $module in $inc" };
		unless ( -r $dir ) {
			croak("Found directory '$dir', but no read permissions");
		}
		return $dir;
	}
	return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

File::ShareDir2::Resolver::Perl - ShareDir 1.0 @INC resolver

=head1 VERSION

version 0.001000

=head1 AUTHOR

Adam Kennedy <adamk@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2005 by Adam Kennedy <adamk@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
