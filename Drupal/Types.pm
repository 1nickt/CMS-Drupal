package CMS::Drupal::Types;
 
use v5.10;
 
use strict;
use warnings;
 
our $VERSION = "0.99";
our $VERSION_DATE = "June, 2015";
 
use Type::Library -base, -declare => qw/ Database
                                         Username
                                         Password
                                         Host
                                         Port
                                         Prefix /;
use Type::Utils qw/ :all /;
use Types::Standard qw/ Optional Maybe Str Int slurpy Dict /;

declare Database, as Str, where { length($_) > 0 },
  message { "You must supply the database name. " };

declare Username, as Optional[Str],
  message { "The username must be a string. " };

declare Password, as Optional[Str],
  message { "The password must be a string. " };

declare Host,     as Optional[Str],
  message { "The hostname must be a string. " };

declare Port,     as Optional[Int],
  message { "The port number must be an integer." };

declare Prefix,   as Optional[Str], where { $_ =~ m/\w+_/ },
  message { "The table prefix must end in an underscore." };

1; ## return true to end package CMS::Drupal::Types
