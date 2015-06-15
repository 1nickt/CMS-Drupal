#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use ExtUtils::MakeMaker;
use Test::More;
use Test::Database;
use CMS::Drupal;
use Data::Dumper;
use Carp;

my @handles = Test::Database->handles( { 'dbd' => 'mysql' });

my $drupal = CMS::Drupal->new;
my %params;

if ( prompt( "\nWould you like to test the module on your Drupal database?", 'Yes') !~ m/Yes/i) {
  say "\nOK. Testing with a mock database.";
} else {
  if ( exists $ENV{'DRUPAL_TEST_CREDS'} ) {
     %params = ( split ',', $ENV{'DRUPAL_TEST_CREDS'} );
  } else {
    my $database = prompt("\nPlease enter the name of your Drupal MySQL database:");
    if (! $database) {
      #skip the tests
      say "Skipping";
      exit 1;
    } else {
      my $username = prompt( "\nPlease enter the database username, if any:" );
      my $password = prompt( "\nPlease enter the database user password, if any:" );
      my $host     = prompt( "\nPlease enter the hostname of the server:", 'localhost' );
      my $port     = prompt( "\nPlease enter the port number for the database server:", '3306' );
      my $prefix   = prompt( "\nPlease enter the schema prefix for the tables, if any:" );

      %params = (
        'username' => $username || '',
        'password' => $password || '',
        'host'     => $host,
        'port'     => $port
      );

      $prefix and $params{'prefix'} = $prefix; # Empty string fails the type validation
    }
  }
}

ok( my $dbh = $drupal->dbh( %params ), 'got a dbh with the credentials' );

done_testing();

