use inc::Module::Install;

# Define metadata
name 'SSH-Herd';
all_from 'lib/SSH/Herd.pm';

# Specific dependencies
requires 'Config::Any';
requires 'File::HomeDir';
requires 'FindBin';
requires 'Moose';
requires 'MooseX::Types::Path::Class';
requires 'MooseX::Types';
requires 'Number::Range';
requires 'Regexp::Common';

# for testing
test_requires 'Test::More';
test_requires 'Test::Deep';

WriteAll;
