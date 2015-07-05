#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 17;

# CMS::Drupal test 01 - object and parameter validation

BEGIN {
  use_ok( 'CMS::Drupal',
    'use() the module.' ) or die;
}

my $drupal = CMS::Drupal->new;

ok( defined $drupal,
  'Get something from Drupal->new().' );

isa_ok( $drupal, "CMS::Drupal",
  '$drupal is of the correct class.' );

ok( ! eval{ $drupal->dbh(driver => 'bar') },
  'Correctly fail to connect with missing database param.' );

ok( ! eval{ $drupal->dbh(database => '', driver => 'bar') },
  'Correctly fail to connect with empty string for database param.' );

ok( ! eval{ $drupal->dbh(database => 'foo') },
  'Correctly fail to connect with missing driver param.' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => '') },
  'Correctly fail to connect with empty driver param.' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => []) },
  'Correctly fail to connect with non-string for driver [array].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'bar') },
  'Correctly fail to connect with unknown driver param.' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', username => []) },
  'Correctly fail to connect with non-string for username [array].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', password => []) },
  'Correctly fail to connect with non-string for password [array].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', host => []) },
  'Correctly fail to connect with non-string for host [array].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', port => []) },
  'Correctly fail to connect with non-string for port [array].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', port => 'baz') },
  'Correctly fail to connect with non-integer for port [string].' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', prefix => 'quux') },
  'Correctly fail to connect with no trailing underscore for prefix.' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', prefix  => '_') },
  'Correctly fail to connect with only underscore for prefix.' );

ok( ! eval{ $drupal->dbh(database => 'foo', driver => 'Pg', prefix  => '') },
  'Correctly fail to connect with empty string for prefix.' );

say '-' x 78;

__END__
