package SSH::Herd::Types;
use Regexp::Common qw /net/;
use Number::Range;

use MooseX::Types -declare, [
    qw(
      Host
      Atom
      HostList
      AtomString
      NotAtomString
      DerivedHostString
      )
];

# import builtin types
use MooseX::Types::Moose 'Str', 'ArrayRef';

subtype Atom, as Str, where { $_ =~ /\[([\d.,]+)\]/ };

subtype Host, as Str, where { $_ =~ /$RE{net}{domain}/ };

subtype HostList, as ArrayRef, where {
    my $list = $_;
    0 == grep { !is_Host($_) } @$list;
};

subtype AtomString, as Str, where {
    my $str = $_;
    my @atoms = grep { is_Atom($_) } ( split /\s+/, $str );
    return @atoms != 0;
};

subtype NotAtomString, as Str, where { not is_AtomString($_) };

subtype DerivedHostString, as Str, where { $_ =~ /\{\w+\}/ };

coerce HostList, from DerivedHostString, via { [$_] };

coerce HostList, from NotAtomString, via { [ split /\s+/, $_ ] };

coerce HostList, from AtomString, via {
    [ map { expand_atom($_) } split /\s+/, $_ ];
};

sub expand_atom {
    my ($atom) = @_;
    my ($range) = $atom =~ /\[([\d.,]+)\]/;

    return $atom unless defined $range;

    return
      map { ( my $v = $atom ) =~ s/\[$range\]/$_/; $v }
      Number::Range->new($range)->range;
}
