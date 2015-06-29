#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use Test::More tests => 17;

say "+" x 70;
say "CMS::Drupal test 01 - object and parameter validation.";

use_ok( 'CMS::Drupal',                                             'use() the module.' );
my $drupal = CMS::Drupal->new;
ok( defined $drupal,                                               'Drupal->new() returned something.' );
ok( $drupal->isa('CMS::Drupal'),                                   'The object is of the correct class.' );
ok( ! eval{ $drupal->dbh(driver => 'bar') },                       'Fail to connect with missing database param.' );
ok( ! eval{ $drupal->dbh(database => '', driver => 'bar') },       'Fail to connect with empty string for database.' );
ok( ! eval{ $drupal->dbh(database => 'foo') },                     'Fail to connect with missing driver param.' );
ok( ! eval{ $drupal->dbh(database => 'foo', driver   => '') },     'Fail to connect with empty driver param.' );
ok( ! eval{ $drupal->dbh(database => 'foo', driver   => []) },     'Fail to connect with non-string for driver [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', driver   => 'bar') },  'Fail to connect with unknown driver param.' );
ok( ! eval{ $drupal->dbh(database => 'foo', username => []) },     'Fail to connect with non-string for username [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', password => []) },     'Fail to connect with non-string for password [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', host     => []) },     'Fail to connect with non-string for host [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', port     => []) },     'Fail to connect with non-string for port [array].' );
ok( ! eval{ $drupal->dbh(database => 'foo', port     => 'baz') },  'Fail to connect with non-integer for port [string].' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix   => 'quux') }, 'Fail to connect with no trailing underscore for prefix.' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix   => '_') },    'Fail to connect with only underscore for prefix.' );
ok( ! eval{ $drupal->dbh(database => 'foo', prefix   => '') },     'Fail to connect with empty string for prefix.' );

say "+" x 70;

