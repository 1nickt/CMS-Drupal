#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use Test::More;

say "+" x 70;
say "CMS::Drupal test 01 - object and parameter validation.";
say '';

use_ok( 'CMS::Drupal', 'use() the module.' );

my $drupal = CMS::Drupal->new;

ok( defined $drupal,                                               'Drupal->new() returned something.' );
ok( $drupal->isa('CMS::Drupal'),                                   'The object is of the correct class.' );
ok( ! $drupal->dbh(),                                              'Fail to connect with missing database param.' );
ok( ! eval{ $drupal->dbh(database => '') },                        'Fail to connect with empty string for database.' );
ok( ! eval{ $drupal->dbh(database => 'foo', username => []) },     'Fail to connect with non-string for username [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', password => []) },     'Fail to connect with non-string for password [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', host => []) },         'Fail to connect with non-string for host [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', port => []) },         'Fail to connect with non-string for port [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', port => 'bar') },      'Fail to connect with non-integer for port [string].' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => 'baz') },    'Fail to connect with no trailing underscore for prefix.' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => '_') },      'Fail to connect with only underscore for prefix.' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix => '') },       'Fail to connect with empty string for prefix.' );

done_testing();

say '';

