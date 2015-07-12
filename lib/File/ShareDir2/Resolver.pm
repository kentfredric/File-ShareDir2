use 5.006;    # our
use strict;
use warnings;

package File::ShareDir2::Resolver;

# ABSTRACT: A base class for Shared Path resolvers

our $VERSION = '0.001000';

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

sub new {
	my ( $package, @args ) = @_;
	use warnings FATAL => 'misc';    # Error on unbalanced @args
	return bless { ref $args[0] ? %{ $args[0] } : @args }, $package;
}

sub dist_dir {
  my ( $self, $distname ) = @_;
  return;
}

sub dist_file {
	my ( $self, $distname, $filename ) = @_;
	my $distdir = $self->dist_dir($distname);
	return unless defined $distdir;
	require File::Spec;
	my $path = File::Spec->catfile( $distdir, $filename );
	return unless -e $path;
	unless ( -f $path ) {
		Carp::croak("Found dist_file '$path', but not a file");
	}
	unless ( -r $path ) {
		Carp::croak("File '$path', no read permissions");
	}
	return $path;
}

sub module_dir {
  my ( $self, $module_name ) = @_;
  return;
}

sub module_file {
	my ( $self, $modulename, $filename ) = @_;
	my $moduledir = $self->module_dir($modulename);
	return unless defined $moduledir;
	require File::Spec;
	my $path = File::Spec->catfile( $moduledir, $filename );
	return unless -e $path;
	unless ( -r $path ) {
		Carp::croak("File '$filename' cannot be read, no read permissions");
	}
	return $path;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

File::ShareDir2::Resolver - A base class for Shared Path resolvers

=head1 VERSION

version 0.001000

=head1 AUTHOR

Adam Kennedy <adamk@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2005 by Adam Kennedy <adamk@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
