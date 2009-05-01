#!/usr/bin/env perl -wl
use lib qw(lib);

package SSH::Herd::App::Fornodes;
use Moose;
use SSH::Herd;

with qw(
  MooseX::Getopt
  SSH::Herd::Config
);

has _herd => (
    isa        => 'SSH::Herd',
    is         => 'ro',
    lazy_build => 1,
    handles    => [qw(get_hosts)],
);

sub _build__herd { SSH::Herd->new( config => shift->config ) }

sub run {
    print for map { $_[0]->get_hosts($_) } @{ $_[0]->extra_argv };
}

__PACKAGE__->new_with_options()->run;
no Moose;
1;
__END__
