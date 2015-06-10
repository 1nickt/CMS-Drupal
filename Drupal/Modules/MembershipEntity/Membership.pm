package CMS::Drupal::Modules::MembershipEntity::Membership;

use vars qw($VERSION $VERSION_DATE);
$VERSION = "0.99";
$VERSION_DATE = "June, 2015";
 
use Moo;
use Types::Standard qw/ :all /;
use Data::Dumper;

has mid       => ( is => 'ro', isa => Int, required => 1 );
has created   => ( is => 'ro', isa => Int, required => 1 );
has changed   => ( is => 'ro', isa => Int, required => 1 );
has uid       => ( is => 'ro', isa => Int, required => 1 );
has status    => ( is => 'ro', isa => Int, required => 1 );
has member_id => ( is => 'ro', isa => Int, required => 1 );
has type      => ( is => 'ro', isa => Str, required => 1 );
has terms     => ( is => 'ro', isa => HashRef, required => 1 );

1; ## return true to end package MembershipEntity::Membership
