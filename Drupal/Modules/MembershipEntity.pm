package CMS::Drupal::Modules::MembershipEntity;

use Moo;
use Types::Standard qw/ :all /;

has database_handle => ( is => 'ro', isa => InstanceOf['DBI::db'], required => 1 );

sub fetch_all_memberships {
  my $self = shift;
  $self->{ _all_memberships } =
    $self->{ database_handle }->selectall_hashref( "select * from membership_entity", 'mid' );
  return $self->{ _all_memberships };
}

sub count_all_memberships {
  my $self = shift;
  $self->{ _count_all_memberships } =
    $self->{ database_handle }->selectrow_array( "select count(mid) from membership_entity" );
  return $self->{ _count_all_memberships };
}

sub count_expired_memberships {
  my $self = shift;
  $self->{ _count_expired_memberships } =
    $self->{ database_handle }->selectrow_array( "select count(mid) from membership_entity where status = 0" );
  return $self->{ _count_expired_memberships };
}

sub count_active_memberships {
  my $self = shift;
  $self->{ _count_active_memberships } =
    $self->{ database_handle }->selectrow_array( "select count(mid) from membership_entity where status = 1" );
  return $self->{ _count_active_memberships };
}

sub count_cancelled_memberships {
  my $self = shift;
  $self->{ _count_cancelled_memberships } =
    $self->{ database_handle }->selectrow_array( "select count(mid) from membership_entity where status = 2" );
  return $self->{ _count_cancelled_memberships };
}

sub count_pending_memberships {
  my $self = shift;
  $self->{ _count_pending_memberships } =
    $self->{ database_handle }->selectrow_array( "select count(mid) from membership_entity where status = 3" );
  return $self->{ _count_pending_memberships };
}

sub percentage_active_memberships {
  my $self = shift;
  $self->{ _percentage_active_memberships } = sprintf("%.2f%%", (($self->count_active_memberships / $self->count_all_memberships) * 100));
  return $self->{ _percentage_active_memberships };
}

sub percentage_expired_memberships {
  my $self = shift;
  $self->{ _percentage_expired_memberships } = sprintf("%.2f%%", (($self->count_expired_memberships / $self->count_all_memberships) * 100));
  return $self->{ _percentage_expired_memberships };
}


1; ## return true to end package CMS::Drupal::Modules::MembershipEntity
