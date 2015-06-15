#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use Test::More;
use CMS::Drupal;

say "+" x 70;
say "CMS::Drupal test 01 - object and parameter validation.";
say '';

my $drupal = CMS::Drupal->new;

ok( defined $drupal,                                               'new() returned something' );
ok( $drupal->isa('CMS::Drupal'),                                   'object is of the correct class' );
ok( ! $drupal->dbh(),                                              'missing database param' );
ok( ! eval{ $drupal->dbh(database => '') },                        'empty string for database' );
ok( ! eval{ $drupal->dbh(database => 'foo', username => []) },     'non-string for database [array]' );
ok( ! eval{ $drupal->dbh(database => 'foo', username => sin(3)) }, 'non-string for database [number]' );
ok( ! eval{ $drupal->dbh(database => 'foo', password => []) },     'non-string for password [array]' );
ok( ! eval{ $drupal->dbh(database => 'foo', password => sin(3)) }, 'non-string for password [number]' );
ok( ! eval{ $drupal->dbh(database => 'foo', host => []) },         'non-string for host [array]' );
ok( ! eval{ $drupal->dbh(database => 'foo', host => sin(3)) },     'non-string for host [number]' );
ok( ! eval{ $drupal->dbh(database => 'foo', port => []) },         'non-string for port [array]' );
ok( ! eval{ $drupal->dbh(database => 'foo', port => 'bar') },      'non-integer for port [string]' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => 'baz') },    'no trailing underscore for prefix' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => '_') },      'only underscore for prefix' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => '') },       'empty string for prefix' );

done_testing();

say '';

