package CMS::Drupal;

use strict;
use warnings;
use v5.10;

use Moo;
use Types::Standard    qw/ Optional Maybe Str Int slurpy Dict /;
use CMS::Drupal::Types qw/ Database DBUsername DBPassword DBHost DBPort DBPrefix /;
use Type::Params       qw/ compile /;

use DBI;
use Carp qw/ confess croak /;
use Data::Dumper;

sub dbh {
  my $self = shift;
  return $self->{'_dbh'} if defined( $self->{'_dbh'} );

  my $args = { @_ };

  return 0 unless exists $args->{'database'};

  my %types = (
    database => Database,
    username => DBUsername,
    password => DBPassword,
    host     => DBHost,
    port     => DBPort,
    prefix   => DBPrefix,
  );

  for( keys %$args ) {
    my $validate = compile( slurpy Dict [ $_ => $types{$_} ]);
    my ($param) = $validate->( $_ => $args->{$_} );
  }

  my $dsn = 'dbi:mysql:' . $args->{'database'};
  exists $args->{'host'} and $dsn .= (';host=' . $args->{'host'});
  exists $args->{'port'} and $dsn .= (';port=' . $args->{'port'});
  my $username = (exists $args->{'username'} ? $args->{'username'} : '');
  my $password = (exists $args->{'password'} ? $args->{'password'} : '');
  $self->{'_dbh'} = DBI->connect( $dsn, $username, $password, { 'RaiseError' => 1} );
  
  return $self->{'_dbh'};
}

1; ## return true to end package CMS::Drupal

=pod
 
=head1 NAME
 
CMS::Drupal -- Perl module to interface with the Drupal CMS
 
=head1 SYNOPSIS
 
 use CMS::Drupal;           

 my $drupal = CMS::Drupal->new(
  'database' => "my_db",
  'username' => "my_user",
  'password' => "my_password",
  'host'     => "my_host",
  'port'     => "3306",
  'driver'   => "mysql",
  'prefix"   => "myapp_"
 );

 my $database_handle = $drupal->dbh;
 
=head1 DESCRIPTION

This module provides a Perl interface to a Drupal CMS website.

Since you can't do anything with Drupal until you can talk to the (MySQL) database, this module takes the database credentials as parameters to the object constructor.

The database handle is returned by the $drupal->dbh() method call.

As of this writing, all I need is a DB handle so I can use other CMS::Drupal::* modules. You are welcome to contribute code if you want this module to do anything else. For example, many CMS interfaces allow you to put the CMS into "maintenance mode," so you can work on the database with the site off-line. It would be relatively simple to add methods for tasks such as that.

=head1 USAGE

Use the module as shown in the Synopsis above.

=head2 PARAMETERS

B<database> The name of your Drupal database. Required.

B<username> The database username. Optional. Must be a string if supplied.

B<password> The database password. Optional. Must be a string if supplied.

B<host> The name or IP address of the server where your Drupal database lives. Optional. Must be a string if supplied.

B<port> The port on which to connect to the MySQL server. Optional. Must be an integer if supplied.

B<prefix> The prefix that you set in Drupal for your database table names (if any). Optional. Must ve at least two characters and end with an underscore (e.g. "foo_").

=head1 AUTHOR
 
Author: Nick Tonkin (nick@websitebackendsolutions.com)
 
=head1 COPYRIGHT
 
Copyright (c) 2015 Nick Tonkin. All rights reserved.
 
=head1 LICENSE
 
You may distribute this module under the same license as Perl itself.
 
=head1 SEE ALSO

L<CMS::Drupal::Types>

CMS::Drupal::Modules::*
 
=cut


