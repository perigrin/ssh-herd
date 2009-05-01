#!/usr/bin/env perl
use strict;
use Test::More tests => 3;
use Test::Deep;
use FindBin ();

{

    package Test;
    use Moose;
    with qw(SSH::Herd::Config);
    sub _build_configfile { "$FindBin::Bin/fornodes.cnf" }
}

ok( my $obj  = Test->new );
ok( my $conf = $obj->config );

is_deeply(
    $conf,
    {
        'bar' => [ 'foo.com', 'bar.org', 'bah.cn', 'baz.com' ],
        'as'  => [
            'ws1101.as.com', 'ws1102.as.com',
            'ws1103.as.com', 'ws1104.as.com',
            'ws1105.as.com'
        ],
        'ps' => [
            'blah.ps.com',  'bloo.ps.com', 'boo2.ps.com',  'boo3.ps.com',
            'boo4.ps.com',  'boo5.ps.com', 'boo32.ps.com', 'boo41.ps.com',
            'boo42.ps.com', 'boo43.ps.com'
        ],
        'foo' => '{ps} + {ps} * {as} - {ps} / {as}',
    }
);
