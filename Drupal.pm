package CMS::Drupal;

use vars qw($VERSION $VERSION_DATE);
 
$VERSION = "0.99";
$VERSION_DATE = "June, 2015";

use Moo;
use Types::Standard qw/ :all /;
use DBI;
use Carp qw/ confess /;

has database => ( is => 'ro', isa => Str, required => 1 );
has username => ( is => 'ro', isa => Str, required => 1 );
has password => ( is => 'ro', isa => Str, required => 1 );
has host     => ( is => 'ro', isa => Str, required => 1 );
has port     => ( is => 'ro', isa => Int, default => 3306 );
has driver   => ( is => 'ro', isa => Str, default => 'mysql' );
has prefix   => ( is => 'ro', isa => sub {
      if ($_[0] and $_[0] !~ /\w+_/) {
        confess("'$_[0]' is not a valid prefix. Database table prefix must end in an underscore.");
      }
    }, default => '' ); # end 'prefix' type check

sub dbh {
  my $self = shift;

  return $self->{'_dbh'} if defined($self->{'_dbh'});

  my $dsn = "dbi:"       . $self->driver .
            ":database=" . $self->database .
            ";host="     . $self->host .
            ";port="     . $self->port;

  $self->{'_dbh'} = DBI->connect($dsn, $self->username, $self->password, {RaiseError => 1});
  
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

The database handle is returned by the $drupal->dbh method call.

As of this writing, all I need is a DB handle so I can use other CMS::Drupal::* modules. You are welcome to contribute code if you want this module to do anything else. For example, many CMS interfaces allow you to put the CMS into "maintenance mode," so you can work on the database with the site off-line. It would be relatively simple to add methods for tasks such as that.

=head1 USAGE

Use the module as shown in the Synopsis above.

=head2 PARAMETERS


B<database> The name of your Drupal database. Required.

B<username> The database username. Required, even if you let MySQL use the default of your system user name.

B<password> The database password. Required, even if MySQL doesn't require one (use "''" [i.e., two single quotes]).

B<host> The name or IP address of the server where your Drupal database lives. Required, even if you let MySQL use the default of your local machine (use "localhost").

B<port> The port on which to connect to the MySQL server. Not required; defaults to MySQL's default of 3306.

B<driver> The name of the Perl DBD database driver to use to connect to the database through the DBI. Not required (and should not be set); defaults to "mysql".

B<prefix> The prefix that you set in Drupal for your database table names (if any). Not required, but if supplied, must end with an underscore (e.g. "foo_").

=head1 AUTHOR
 
Author: Nick Tonkin (nick@websitebackendsolutions.com)
 
=head1 COPYRIGHT
 
Copyright (c) 2015 Nick Tonkin. All rights reserved.
 
=head1 LICENSE
 
You may distribute this module under the same license as Perl itself.
 
=head1 SEE ALSO
 
L<CMS::Drupal::Modules::MembershipEntity>.
 
=cut


