#!/usr/bin/env perl -w
use lib qw(lib);

package SSH::Herd::App::Fornodes;
use Moose;
use SSH::Herd;
use SSH::Herd::Types ':all';

with qw(  MooseX::Getopt );

has configfile => (
    isa        => 'Str',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_configfile {
    my $home = File::HomeDir->my_home;
    confess "Can't find the home for the current user.\n"
      unless defined $home;
    return "$home/.fornodesrc";
}

has expand_list => (
    isa     => 'Bool',
    is      => 'ro',
    default => 1,
);

has _herd => (
    isa        => 'SSH::Herd',
    is         => 'ro',
    lazy_build => 1,
    handles    => [qw(get_hosts is_set_name)],
);

sub _build__herd {
    SSH::Herd->new(
        $_[0]->has_configfile ? ( configfile => $_[0]->configfile ) : () );
}

sub run {
    my ($self) = @_;
    my $n = ( $self->expand_list ? "\n" : '' );

    for my $line ( @{ $self->extra_argv } ) {
        if ( is_AtomString($line) ) {
            print "${_}${n}" for @{ to_HostList($line) };
        }
        if ( $self->is_set_name($line) ) {
            print "${_}${n}" for $self->get_hosts($line);
        }
    }
}

__PACKAGE__->new_with_options()->run;
no Moose;
1;
__END__
