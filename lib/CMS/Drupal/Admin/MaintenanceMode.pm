package CMS::Drupal::Admin::MaintenanceMode;

# ABSTRACT: Put your Drupal site into Maintenance Mode, or take it out

use strict;
use 5.010;

use base "Exporter::Tiny";
our @EXPORT = qw/ maintenance_mode_check
                  maintenance_mode_on
                  maintenance_mode_off /;

sub maintenance_mode_check {
  my $dbh = shift;

  my $sql = qq|
    SELECT value
    FROM variable
    WHERE name = 'maintenance_mode'
  |;

  return ($dbh->selectrow_array( $sql ) eq 'i:1;')
    ? 1 : 0;
}

sub maintenance_mode_on {
  my $dbh = shift;

  my $sql1 = qq|
    UPDATE variable
    SET value = 'i:1;'
    WHERE name = 'maintenance_mode'
  |;

  my $rv1 = $dbh->do( $sql1 );

  my $sql2 = qq|
    DELETE FROM cache_bootstrap
    WHERE cid = 'variables'
  |;

  my $rv2 = $dbh->do( $sql2 );

  # cache_bootstrap may not have an entry
  # for 'variables' so we allow 0E0
  return ($rv1 > 0  and $rv2 >= 0)
    ? 1 : 0;
}

sub maintenance_mode_off {
  my $dbh = shift;

  my $sql1 = qq|
    UPDATE variable
    SET value = 'i:0;'
    WHERE name = 'maintenance_mode'
  |;

  my $rv1 = $dbh->do( $sql1 );

  my $sql2 = qq|
    DELETE FROM cache_bootstrap
    WHERE cid = 'variables'
  |;

  my $rv2 = $dbh->do( $sql2 );

  # cache_bootstrap may not have an entry
  # for 'variables' so we allow 0E0
  return ($rv1 > 0 and $rv2 >= 0)
    ? 1 : 0;
}

1; # return true

=pod

=head1 NAME

CMS::Drupal::Admin::MaintenanceMode

=head1 SYNOPSIS

 use CMS::Drupal::Admin::MaintenanceMode;

 $on = 'yes' if maintenance_mode_check($dbh);
 
 maintenance_mode_on($dbh);

 maintenance_mode_off($dbh);

=head1 DESCRIPTION

foo bar

=head1 USAGE

Use the module as shown in the SYNOPSIS.

=head2 METHODS

=over 4

=item maintenance_mode_check

=item maintenance_mode_on

=item maintenance_mode_off

=back

=cut

