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

my @handles = Test::Database->handles( { 'dbd' => 'mysql' } );

say '+' x 70;
say "CMS::Drupal test 02 - Database tests.";

my $drupal = CMS::Drupal->new;
my %params;

if ( exists $ENV{'DRUPAL_TEST_CREDS'} ) {
  %params = ( split ',', $ENV{'DRUPAL_TEST_CREDS'} );
} else {
  skip the tests
  say "Skipping";
  exit 1;
}

###########

ok( my $dbh = $drupal->dbh( %params ), 'Get a dbh with the credentials.' );

###########

my $sth = $dbh->column_info( undef, $dbh->{ 'Name' }, 'users', '%' );
my @cols = map { $_->[3] } @{ $sth->fetchall_arrayref };
my @wanted_cols = qw/ uid
                      name
                      pass
                      mail
                      theme
                      signature
                      signature_format
                      created
                      access
                      login
                      status
                      timezone
                      language
                      picture
                      init
                      data /;

is_deeply( [ sort @cols ], [ sort @wanted_cols ], 'Get correct column names from users table.');

###########

$sth = $dbh->column_info( undef, $dbh->{ 'Name' }, 'node', '%' );
@cols = map { $_->[3] } @{ $sth->fetchall_arrayref };
@wanted_cols = qw/ nid
                   vid
                   type
                   language
                   title
                   uid
                   status
                   created
                   changed
                   comment
                   promote
                   sticky
                   tnid
                   translate /;

is_deeply( [ sort @cols ], [ sort @wanted_cols ], 'Get correct column names from node table.');

############

my $sql = qq|
  SELECT uid, name, pass, mail, created, access, login, status
  FROM users
  LIMIT 1
|;

$sth = $dbh->prepare( $sql );

ok( $sth->execute(), 'Retrieve a record from the users table.' );

done_testing();

say "+" x 70;

