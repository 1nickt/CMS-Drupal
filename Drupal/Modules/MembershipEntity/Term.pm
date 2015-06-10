package CMS::Drupal::Modules::MembershipEntity::Term;

use vars qw($VERSION $VERSION_DATE);
$VERSION = "0.99";
$VERSION_DATE = "June, 2015";
 
use Moo;
use Types::Standard qw/ :all /;
use Data::Dumper;

has tid            => ( is => 'ro', isa => Int, required => 1 );
has mid            => ( is => 'ro', isa => Int, required => 1 );
has status         => ( is => 'ro', isa => Int, required => 1 );
has term           => ( is => 'ro', isa => Str, required => 1 );
has modifiers      => ( is => 'ro', isa => Str, required => 1 );
has start          => ( is => 'ro', isa => Int, required => 1 );
has end            => ( is => 'ro', isa => Int, required => 1 );
has array_position => ( is => 'ro', isa => Int, required => 1 );

sub is_active {
  my $self = shift;
  return $self->{'status'} eq '1' ? 1 : undef;
}

sub is_current {
  my $self = shift;
  my $now = time;
  return ($self->is_active && ($self->{'start'} <= $now && $now <= $self->{'end'}))
    ? 1 : undef;
}

sub is_future {
  my $self = shift;
  my $now = time;
  return ($self->is_active && ($self->{'start'} > $now)) ? 1 : undef;
}

sub was_renewal {
  my $self = shift;
  return $self->{array_position} > 1 ? 1 : undef;
}

1; ## return true to end package MembershipEntity::Term
