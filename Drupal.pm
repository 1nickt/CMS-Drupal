package CMS::Drupal;

use vars qw($VERSION $VERSION_DATE);
 
$VERSION = "0.99.01";
$VERSION_DATE = "June , 2015";

use Moo;
use Types::Standard qw/ :all /;
use DBI;
use Carp qw/ confess /;
use feature qw/ say /;

has database => ( is => 'ro', isa => Str, required => 1 );
has username => ( is => 'ro', isa => Str, required => 1 );
has password => ( is => 'ro', isa => Str, required => 1 );
has host     => ( is => 'ro', isa => Str, required => 1 );
has port     => ( is => 'ro', isa => Int, default => 3306 );
has driver   => ( is => 'ro', isa => Str, default => 'mysql' );
has prefix   => ( is => 'ro', isa => Str, default => '' );

sub dbh {
  my $self = shift;

  return $self->{'_dbh'} if defined($self->{'_dbh'});

  my $dsn = "dbi:" . $self->driver .
            ":database=" . $self->database .
            ";host=" . $self->host .
            ";port=" . $self->port;

  $self->{'_dbh'} = DBI->connect($dsn, $self->username, $self->password);
  return $self->{'_dbh'};
}


1; ## return true to end package CMS::Drupal

=pod
 
=head1 NAME
 
CMS::Drupal -- Perl module to interface with the Drupal CMS
 
=head1 SYNOPSIS
 
 use CMS::Drupal;           

 my $drupal = CMS::Drupal->new(
  'database' => "my_db"
  'username' => "my_user"
  'password' => "my_password"
  'host'     => "my_host"
 );

 my $database_handle = $drupal->dbh;
 
=head1 DESCRIPTION

This module provides a Perl interface to a Drupal CMS website.

Since you can't do anything with Drupal until you can talk to the (MySQL) database, this module takes the database credentials as parameters to the object constructor.

The database handle is returned by the $drupal->dbh method call. I did think about simply returning a database handle when the object is created, but I wanted to leave room for other methods that somebody might want in the future. As of this writing, all I need is a DB handle so I can use other CMS::Drupal::* modules.

=head1 AUTHOR
 
Author: Nick Tonkin (nick@websitebackendsolutions.com)
 
=head1 COPYRIGHT
 
Copyright (c) 2015 Nick Tonkin. All rights reserved.
 
=head1 LICENSE
 
You may distribute this module under the same license as Perl itself.
 
=head1 SEE ALSO
 
L<CMS::Drupal::Modules::MembershipEntity>.
 
=cut


