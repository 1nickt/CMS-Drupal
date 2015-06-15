#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use Test::More;
use Test::Database;
use CMS::Drupal;

my @handles = Test::Database->handles( { 'dbd' => 'mysql' });

my $drupal = CMS::Drupal->new;

ok( defined $drupal,                                                          'new() returned something' );

ok( $drupal->isa('CMS::Drupal'),                                              'object is of the correct class' );

ok( ! $drupal->dbh(),                                                         'missing database param');

ok( ! eval{ $drupal->dbh(database => '') },                                   'empty string for database');

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', username => []) },     'non-string for database [array]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', username => sin(3)) }, 'non-string for database [number]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', password => []) },     'non-string for password [array]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', password => sin(3)) }, 'non-string for password [number]' );
 
ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', host => []) },         'non-string for host [array]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', host => sin(3)) },     'non-string for host [number]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', port => []) },         'non-string for port [array]' );
 
ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', port => 'foo') },      'non-integer for port [string]' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', prefix => 'foo') },    'no trailing underscore for prefix' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', prefix => '_') },      'only underscore for prefix' );

ok( ! eval{ $drupal->dbh(database => 'cat36ia_d7prod', prefix => '') },       'empty string for prefix' );

done_testing();


