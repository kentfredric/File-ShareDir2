use 5.006;    # our
use strict;
use warnings;

package File::ShareDir2::Resolver;

# ABSTRACT: A base class for Shared Path resolvers

our $VERSION = '0.001000';

# AUTHORITY

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

