package CMS::Drupal;

use Moo;
use Types::Standard qw/ :all /;
use DBI;
use Carp qw/ confess /;
use feature qw/ say /;

has database => ( is => 'ro', isa => Str, required => 1 );
has username => ( is => 'ro', isa => Str, required => 1 );
has password => ( is => 'ro', isa => Str, required => 1 );
has host     => ( is => 'ro', isa => Str, required => 1 );
has port     => ( is => 'ro', isa => Int, default => 3306 );
has driver   => ( is => 'ro', isa => Str, default => 'mysql' );
has prefix   => ( is => 'ro', isa => Str, default => '' );

sub dbh {
  my $self = shift;

  return $self->{'_dbh'} if defined($self->{'_dbh'});

  my $dsn = "dbi:" . $self->driver .
            ":database=" . $self->database .
            ";host=" . $self->host .
            ";port=" . $self->port;

  $self->{'_dbh'} = DBI->connect($dsn, $self->username, $self->password);
  return $self->{'_dbh'};
}


1; ## return true to end package CMS::Drupal
