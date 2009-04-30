package SSH::Herd::Config;
use Moose::Role;
use MooseX::Types::Path::Class qw(File);
use File::HomeDir;
use Config::Any;
use Number::Range;
use Set::Scalar;

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

sub parse_derived {
    my ( $self, $value ) = @_;
    $value =~ s/\{(\w+)\}/'$self->get_set(\''.$1.'\')'/eg;
    $value;
}

sub parse_config {
    my ( $self, $config ) = @_;
    for my $key ( keys %$config ) {
        if ( $config->{$key} =~ /\{\w+\}/ ) {
            my $v = $self->parse_derived( $config->{$key} );
            $config->{$key} = $v;
        }
        else {
            my $v = [ map { expand_atom($_) } split /\s+/, $config->{$key} ];
            $config->{$key} = $v;
        }
    }

    return $config;
}

sub expand_atom {
    my ($atom) = @_;
    if ( $atom =~ /\[([\d.,]+)\]/ ) {
        return
            map { ( my $v = $atom ) =~ s/\[([\d.,]+)\]/$_/; $v; }
            Number::Range->new($1)->range;
    }
    return $atom;
}

no Moose::Role;
1;
__END__
