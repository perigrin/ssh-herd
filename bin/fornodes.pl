#!/usr/bin/env perl -w
package SSH::Herd::App::Fornodes;
use Moose;
use lib qw(lib);

with qw(
    SSH::Herd::Config
    MooseX::Getopt
);

sub run { 
    $_[0]->config;
    die $_[0]->dump;
}

__PACKAGE__->new_with_options()->run;
no Moose;
1;
__END__
