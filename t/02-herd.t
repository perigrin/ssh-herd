#!/usr/bin/env perl
use strict;
use Test::More tests => 7;
use Test::Deep;
use FindBin ();
use SSH::Herd;
ok( my $obj = SSH::Herd->new( configfile => "$FindBin::Bin/fornodes.cnf" ),
    'new SSH::Herd' );

ok( my @hosts = $obj->get_hosts('bar'), 'get_hosts bar' );
is_deeply( \@hosts, [qw(bar.org baz.com bah.cn foo.com )], 'bar looks right' );

ok( my @hosts = $obj->get_hosts('as'), 'get_hosts as' );
is_deeply(
    \@hosts,
    [
        qw(ws1105.as.com ws1102.as.com ws1101.as.com ws1103.as.com ws1104.as.com)
    ],
    'as looks right'
);

ok( my @hosts = $obj->get_hosts('ps'), 'get_hosts ps' );
is_deeply(
    \@hosts,
    [
        qw(boo3.ps.com boo32.ps.com boo42.ps.com bloo.ps.com boo4.ps.com
          blah.ps.com boo43.ps.com boo5.ps.com boo2.ps.com boo41.ps.com)
    ],
    'ps looks right'
);
