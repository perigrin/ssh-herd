package SSH::Herd::Config;
use Moose::Role;

use MooseX::Types::Path::Class qw(File);
use File::HomeDir;

use Config::Any;
use SSH::Herd::Types ':all';

has configfile => (
    isa        => 'Path::Class::File',
    is         => 'ro',
    lazy_build => 1,
    coerce     => 1,
);

sub _build_configfile {
    my $home = File::HomeDir->my_home;
    confess "Can't find the home for the current user.\n"
      unless defined $home;
    return "$home/.fornodesrc";
}

has config => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

sub _build_config {
    my ($self) = @_;
    return $self->parse_config(
        Config::Any->load_files(
            {
                files        => [ $self->configfile->absolute ],
                use_ext      => 0,
                flatten_hash => 1
            }
          )->[0]{ $self->configfile->absolute }
    );
}

sub parse_config {
    my ( $self, $config ) = @_;
    for my $key ( keys %$config ) {
        next if is_DerivedHostString( $config->{$key} );
        $config->{$key} = to_HostList( $config->{$key} );
    }
    return $config;
}

no Moose::Role;
1;
__END__
