package CMS::Drupal;

# ABSTRACT: Perl interface to the Drupal CMS

use strict;
use warnings;

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

  # We want to be able to run with no params if we have them in the env. But
  # we don't want to use those creds when we are running certain tests
  my $args = (exists $ENV{'DRUPAL_TEST_CREDS'} and ! exists $ENV{'DRUPAL_IGNORE_TEST_CREDS'}) ?
               { split(',', $ENV{'DRUPAL_TEST_CREDS'}) } :
               { @_ };

  confess "Fatal error! No database name provided! " unless exists $args->{'database'};
  confess "Fatal error! No dbi:driver provided! "    unless exists $args->{'driver'};

  my %types = (
    'database' => DBName,
    'driver'   => DBDriver,
    'username' => DBUsername,
    'password' => DBPassword,
    'host'     => DBHost,
    'port'     => DBPort,
    'prefix'   => DBPrefix,
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

=head1 SYNOPSIS
 
  use CMS::Drupal;           

  my $drupal = CMS::Drupal->new();

  my $database_handle = $drupal->dbh(
    'database' => "my_db",
    'driver'   => "mysql",
    'username' => "my_user",
    'password' => "my_password",
    'host'     => "my_host",
    'port'     => "3306",
    'prefix'   => "myapp_"
  );

=head1 DESCRIPTION

This module provides a Perl interface to a Drupal CMS website.

Since you can't do anything with Drupal until you can talk to the database,
this module doesn't do anything with the constructor but return a new object.
You can get a database handle to your Drupal by calling ->dbh() with your
database credentials as parameters.

You will need the appropriate DBI driver installed to connect to your
database. The DBI will hint at what you need if you don't have it, so
long as you set the 'driver' parameter correctly.

=head1 USAGE

Use the module as shown in the Synopsis above.

=method new

Instantiates an object in the CMS::Drupal class.

=method dbh

Returns a database handle connected to your Drupal DB.

=head3 Parameters

=for :list
* database
The name of your Drupal database. Required.
* driver
The DBI driver for your database. Required, from [mysql|Pg|SQLite].
* username
The database username. Optional. Must be a string if supplied.
* password
The database password. Optional. Must be a string if supplied.
* host
The server where the DB lives. Optional. Must be a string if supplied.
* port 
port on which to connect. Optional. Must be an integer if supplied.
* prefix
The prefix that you set in Drupal for your DB table names (if any). Optional. Must be at least two characters and end with a "_").

=head3 Testing

The following is taken from t/20_valid_drupal.t and explains how to have this 
module test against your actual Drupal installation.

B<Quote>

=over 4

 This is t/20_valid_drupal.t It tests the CMS::Drupal module against a real Drupal
 database. It looks in your environment to see if you have provided
 connection information.

 So if you want to test against your Drupal DB, you must set the variable

 DRUPAL_TEST_CREDS

 in your environment, exactly as follows:

 required fields are 
   database - name of your DB
   driver   - your dbi:driver ... mysql, Pg or SQLite

 optional fields are
   user     - your DB user name
   password - your DB password
   host     - your DB server hostname
   port     - which port to connect on
   prefix   - your database table schema prefix, if any

 All these fields and values must be joined together in one string with no
 spaces, and separated with commas.

 Examples:

 database,foo,driver,SQLite
 database,foo,driver,Pg
 database,foo,driver,mysql,user,bar,password,baz,host,localhost,port,3306,prefix,My_

 You can set an environment variable in many ways. To make it semi permanent,
 put it in your .bashrc or .bash_profile or whatever you have.

 If you just want to run this test once, you can just do this from your
 command prompt:

 $ DRUPAL_TEST_CREDS=database,foo,driver,SQLite
 $ perl t/20_valid_drupal.t

=back

B<End Quote>
 
If you leave the environment variable set, in future you won't have to supply
any credentials when calling this module's ->dbh() method:

  my $drupal = CMS::Drupal->new;
  my $dbh    = $drupal->dbh; # fatal error usually

It is not recommended to keep your credentials for a production database in
your environment as it's pretty easy to read it ...

=head1 SEE ALSO

=for :list
* L<CMS::Drupal::Types|CMS::Drupal::Types>
* L<CMS::Drupal::Admin|CMS::Drupal::Admin>

