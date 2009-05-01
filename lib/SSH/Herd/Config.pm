package SSH::Herd::Config;
use Moose::Role;

use MooseX::Types::Path::Class qw(File);
use File::HomeDir;

use Config::Any;
use SSH::Herd::Types ':all';

has configfile => (
    isa        => 'Path::Class::File',
    is         => 'ro',
    coerce     => 1,
);


has raw_config => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_raw_config {
    my ($self) = @_;
    Config::Any->load_files(
        {
            files        => [ $self->configfile->absolute ],
            use_ext      => 0,
            flatten_hash => 1
        }
    )->[0]{ $self->configfile->absolute };
}

has config => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_config {
    my ($self) = @_;
    _parse_config( $self->raw_config );
}

sub _parse_config {
    my ($config) = @_;
    for my $key ( keys %$config ) {
        next if is_DerivedHostString( $config->{$key} );
        $config->{$key} = to_HostList( $config->{$key} );
    }
    return $config;
}

no Moose::Role;
1;
__END__
