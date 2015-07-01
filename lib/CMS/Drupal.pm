package CMS::Drupal;

# ABSTRACT: Perl interface to the Drupal CMS

use strict;
use warnings;
use 5.010;

use Moo;
use Types::Standard    qw/ Optional Maybe Str Int slurpy Dict /;
use CMS::Drupal::Types qw/ DBName DBDriver DBUsername DBPassword DBHost DBPort DBPrefix /;
use Type::Params       qw/ compile /;

use DBI;
use Carp qw/ confess croak /;
use Data::Dumper;

sub dbh {
  my $self = shift;
  return $self->{'_dbh'} if defined( $self->{'_dbh'} );

  my $args = { @_ };

  confess "Fatal error! No database name provided! " unless exists $args->{'database'};
  confess "Fatal error! No dbi:driver provided! "    unless exists $args->{'driver'};

  my %types = (
    database => DBName,
    driver   => DBDriver,
    username => DBUsername,
    password => DBPassword,
    host     => DBHost,
    port     => DBPort,
    prefix   => DBPrefix,
  );

  for ( keys %{$args} ) {
    next unless exists $types{ $_ }; # throw away unknown params
    my $validate = compile( slurpy Dict [ $_ => $types{$_} ]);
    my ($param) = $validate->( $_ => $args->{$_} );
  }

  my $dsn = join(':', 'dbi', $args->{'driver'}, $args->{'database'});
  exists $args->{'host'} and $dsn .= (';host=' . $args->{'host'});
  exists $args->{'port'} and $dsn .= (';port=' . $args->{'port'});
  my $username = (exists $args->{'username'} ? $args->{'username'} : '');
  my $password = (exists $args->{'password'} ? $args->{'password'} : '');
  $self->{'_dbh'} = DBI->connect( $dsn, $username, $password, { 'RaiseError' => 1 } );

  return $self->{'_dbh'};
}

1; ## return true to end package CMS::Drupal
__END__

=pod
 
=head1 NAME
 
CMS::Drupal -- Perl interface to the Drupal CMS
 
=head1 SYNOPSIS
 
 use CMS::Drupal;           

 my $drupal = CMS::Drupal->new(
  'database' => "my_db",
  'driver'   => "mysql",
  'username' => "my_user",
  'password' => "my_password",
  'host'     => "my_host",
  'port'     => "3306",
  'prefix"   => "myapp_"
 );

 my $database_handle = $drupal->dbh;
 
=head1 DESCRIPTION

This module provides a Perl interface to a Drupal CMS website.

Since you can't do anything with Drupal until you can talk to the database,
this module takes the database credentials as parameters to the object
constructor.

You will need the appropriate DBI driver installed to connect to your
database. The DBI will hint at what you need if you don't have it, so
long as you set the 'driver' parameter correctly.

The database handle is returned by the $drupal->dbh() method call.


=head1 FUNCTIONALITY

As of this writing, all the author needs is a DB handle in order to use other
CMS::Drupal::* modules. You are welcome to contribute code if you want this
module to do anything else. For example, many CMS interfaces allow you to put
the CMS into "maintenance mode," so you can work on the database with the
site off-line. It would be relatively simple to add methods for tasks such as
that.

=head1 USAGE

Use the module as shown in the Synopsis above.

=head2 PARAMETERS

B<database>
 The name of your Drupal database. Required.

B<driver>
 The DBI driver for your database. Required, from [mysql|Pg|SQLite].

B<username>
 The database username. Optional. Must be a string if supplied.

B<password>
 The database password. Optional. Must be a string if supplied.

B<host>
 The server where the DB lives. Optional. Must be a string if supplied.

B<port>
 The port on which to connect. Optional. Must be an integer if supplied.

B<prefix>
 The prefix that you set in Drupal for your DB table names (if any).
 Optional. Must be at least two characters and end with a "_").

=head1 AUTHOR
 
Author: Nick Tonkin (tonkin@cpan.org)

=head1 COPYRIGHT
 
Copyright (c) 2015 Nick Tonkin. All rights reserved.
 
=head1 LICENSE
 
You may distribute this module under the same license as Perl itself.
 
=head1 SEE ALSO

L<CMS::Drupal::Types|CMS::Drupal::Types>

=cut

