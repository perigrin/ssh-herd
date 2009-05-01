package SSH::Herd;
use Moose;

with qw(SSH::Herd::Config);

has sets => (
    isa => 'HashRef',
    is  => 'ro',    
    lazy_build => 1,
);

sub _build_sets {
    shift->config;
}

sub get_hosts {
    my ( $self, $key ) = @_;
    my $set = $self->sets->{$key};
    @$set;
}

no Moose;
1;
__END__
