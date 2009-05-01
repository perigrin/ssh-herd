package SSH::Herd;
use Moose;

with qw(SSH::Herd::Config);

sub get_hosts {
    my ( $self, $key ) = @_;
    my $hosts = $self->config->{$key};
    return @$hosts;
}

no Moose;
1;
__END__
