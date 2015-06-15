package CMS::Drupal::Types;
 
use v5.10;
 
use strict;
use warnings;
 
our $VERSION = "0.99";
our $VERSION_DATE = "June, 2015";

use Type::Library -base, -declare => qw/ Database
                                         DBUsername
                                         DBPassword
                                         DBHost
                                         DBPort
                                         DBPrefix /;
use Type::Utils qw/ :all /;
use Types::Standard qw/ Optional Maybe Str StrMatch Int slurpy Dict /;

declare Database, as Str, where { length($_) > 0 },
  message { "You must supply the database name. " };

declare DBUsername, as Optional[Str],
  message { "The username must be a string. " };

declare DBPassword, as Optional[Str],
  message { "The password must be a string. " };

declare DBHost, as Optional[Str],
  message { "The hostname must be a string. " };

declare DBPort, as Optional[Int],
  message { "The port number must be an integer." };

declare DBPrefix, as Optional[StrMatch[ qr/\w+_/x ]],
  message { DPPrefix->validate($_) or "The table prefix must end in an underscore." };

1; ## return true to end package CMS::Drupal::Types

=pod

=head1 NAME

CMS::Drupal::Types - A Perl type library for working with Drupal

=head1 SYNOPSIS

  use Types::Standard;
  use CMS::Drupal::Types qw/ :all /;

=head1 USAGE

You can use this module to import Type::Tiny-style types relevant to Drupal into your program. Use the syntax shown above and the types will be available as object attributes.

If you want to use the types to validate parameters passed to a method or a sub, use the following syntax as an example:


  use CMS::Drupal::Types qw/ Database DBUsername DBPassword DBHost DBPort DBPrefix /;
  use Types::Standard    qw/ Optional Maybe Str Int slurpy Dict /;
  use Type::Params       qw/ compile /;

  sub my_sub {
    my $args = { @_ };
    my %types = (
      database => Database,
      username => DBUsername,
      password => DBPassword,
      host     => DBHost,
      port     => DBPort,
      prefix   => DBPrefix,
    );
   
    for( keys %$args ) {
      my $validate = compile( slurpy Dict [ $_ => $types{$_} ]);
      my ($param) = $validate->( $_ => $args->{$_} );
      say "$_: '$args->{$_}' passed";
    }
  }

=head2 TYPES

B<Database>
 Must be a non-empty string.

B<DBUsername>
 Must be a string if present. May be empty. May be omitted.

B<DBPassword>
 Must be a string if present. May be empty. May be omitted.

B<DBHost>
 Must be a string if present. May be empty. May be omitted.

B<DBPort>
 Must be an integer if present. May be empty. May be omitted.

B<DBPrefix>
 Must be a string ending in an underscore if present. May be omitted.


=head1 AUTHOR
 
Author: Nick Tonkin (nick@websitebackendsolutions.com)
 
=head1 COPYRIGHT
 
Copyright (c) 2015 Nick Tonkin. All rights reserved.
 
=head1 LICENSE
 
You may distribute this module under the same license as Perl itself.
 
=head1 SEE ALSO

L<CMS::Drupal>.

L<Type::Tiny>

L<Type::Library>

L<Types::Standard>

L<Type::Params>

=cut

