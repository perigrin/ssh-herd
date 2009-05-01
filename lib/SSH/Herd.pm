package SSH::Herd;
use Moose;
use Set::Scalar;
use SSH::Herd::Types ':all';

with qw(SSH::Herd::Config);

has sets => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_sets {
    my ($self) = @_;
    my $config = $self->config;
    my $sets   = {};
    for my $key ( keys %$config ) {
        my $value = $config->{$key};
        if ( is_HostList($value) ) {
            $value = Set::Scalar->new(@$value);
        }
        $sets->{$key} = $value;
    }
    $_ = $self->expand_derived_list($_, $sets)
      for ( grep { !blessed $_ } values %$sets );
    return $sets;
}

sub expand_derived_list {
    my ( $self, $list, $sets ) = @_;
    $list =~ s/{(\w+)}/\$\$sets{$1}/g;
    my $set = eval $list;
    if ($@) { confess $@}
    return $set;
}

sub is_set_name {
    my ( $self, $key ) = @_;
    exists $self->sets->{$key};
}

sub get_hosts {
    my ( $self, $key ) = @_;
    my $set = $self->sets->{$key};
    $set->members;
}

no Moose;
1;
__END__
