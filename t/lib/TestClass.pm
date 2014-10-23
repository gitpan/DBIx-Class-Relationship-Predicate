package TestClass;

use strict;
use warnings;
use Test::Schema;

BEGIN {
  use parent 'Test::Builder::Module';
  use Test::More;
  @TestClass::EXPORT = @Test::More::EXPORT;
};

sub schema_class {
    my $schema_class = 'Test::Schema';
    return $schema_class;
}

sub connect_info { [ 'dbi:SQLite:t/var/test_schema.db' ] }

sub schema {
    my ( $class, $args ) = @_;
    my $schema_class = $class->schema_class;

    my $schema = $schema_class->connect(@{$class->connect_info});
    $schema->deploy({ add_drop_table => 1 });
    $class->populate_schema($schema) if $args->{'populate'};

    return $schema;
}

sub populate_schema {
  my ( $class, $schema ) = @_;
  $schema->populate('Foo' => [
    [ qw/ first_name last_name / ],
    [ "Joe", "Bloggs" ],
    [ "John", "Smith" ],
  ]);

  $schema->populate('Bar' => [
    [ qw/ name foo_id / ],
    map { [ "Bar $_", $_ % 2 ? 1 : 2 ] } (1 .. 4)
  ]);

  $schema->populate('Buzz' => [
    [ qw/ name foo_id / ],
    [ "Joe's Buzz", 1 ]
  ]);
}

1;
