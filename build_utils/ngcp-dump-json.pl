#!/usr/bin/env perl

use strict;
use warnings;

use DBI;
use JSON::XS;
use Getopt::Long;
use Carp;

my $queries = {
tables => <<"__SQL__"
SELECT
  TABLE_NAME,
  ENGINE,
  TABLE_COLLATION,
  CREATE_OPTIONS,
  TABLE_NAME AS key_col
FROM information_schema.TABLES
  WHERE TABLE_SCHEMA = ?
    AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME
__SQL__
,

columns => <<"__SQL__"
SELECT
  c.TABLE_NAME,
  c.COLUMN_NAME,
  c.COLUMN_DEFAULT,
  c.IS_NULLABLE,
  c.COLUMN_TYPE,
  c.EXTRA,
  c.CHARACTER_SET_NAME,
  c.COLLATION_NAME,
  c.ORDINAL_POSITION,
  CONCAT(c.TABLE_NAME, '/', c.COLUMN_NAME) AS key_col
FROM information_schema.COLUMNS c
  INNER JOIN information_schema.TABLES t
    ON c.TABLE_NAME = t.TABLE_NAME
WHERE t.TABLE_TYPE = 'BASE TABLE'
  AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
  AND t.TABLE_SCHEMA = ?
ORDER BY c.TABLE_NAME, c.COLUMN_NAME
__SQL__
,

indexes => <<"__SQL__"
SELECT
  TABLE_NAME,
  INDEX_NAME,
  NON_UNIQUE,
  COLUMN_NAME,
  SEQ_IN_INDEX,
  COLLATION,
  SUB_PART,
  NULLABLE,
  INDEX_TYPE,
  CONCAT(TABLE_NAME, '/', INDEX_NAME, '/',  SEQ_IN_INDEX) AS key_col
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = ?
ORDER BY TABLE_NAME, INDEX_NAME, COLUMN_NAME
__SQL__
,

constraints => <<"__SQL__"
SELECT
  rc.CONSTRAINT_NAME,
  rc.TABLE_NAME,
  rc.REFERENCED_TABLE_NAME,
  rc.UPDATE_RULE,
  rc.DELETE_RULE,
  cu.REFERENCED_COLUMN_NAME,
  cu.COLUMN_NAME,
  CONCAT(  rc.TABLE_NAME, '/', rc.CONSTRAINT_NAME, '/',
    cu.COLUMN_NAME, '/', rc.REFERENCED_TABLE_NAME, '/',
    cu.REFERENCED_COLUMN_NAME) AS key_col
FROM information_schema.REFERENTIAL_CONSTRAINTS rc
  LEFT JOIN information_schema.KEY_COLUMN_USAGE cu
    ON (rc.CONSTRAINT_NAME=cu.CONSTRAINT_NAME
      AND rc.CONSTRAINT_SCHEMA=cu.CONSTRAINT_SCHEMA)
WHERE rc.CONSTRAINT_SCHEMA = ?
ORDER BY CONSTRAINT_NAME, rc.TABLE_NAME, cu.COLUMN_NAME
__SQL__
,

triggers => <<"__SQL__"
SELECT
  TRIGGER_NAME,
  EVENT_MANIPULATION,
  ACTION_STATEMENT,
  ACTION_TIMING,
  EVENT_OBJECT_SCHEMA,
  EVENT_OBJECT_TABLE,
  CONCAT(TRIGGER_NAME, '/', EVENT_OBJECT_TABLE) AS key_col
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = ?
ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME
__SQL__
,

views => <<"__SQL__"
SELECT
  TABLE_NAME AS key_col,
  VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = ?
ORDER BY TABLE_NAME
__SQL__
,

routines => <<"__SQL__"
SELECT
  ROUTINE_NAME AS key_col,
  ROUTINE_DEFINITION,
  ROUTINE_TYPE
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = ?
__SQL__
,
};

my $argv;
GetOptions(
    'socket=s' => \$argv->{socket},
    'schema=s' => \$argv->{schema},
);

my $dbh = DBI->connect("DBI:mysql:;mysql_socket=$argv->{socket}",
    'root',
    '',
    {RaiseError => 1}) or
        croak("Can't connect to db: DBI:mysql:;mysql_socket=$argv->{socket}");

my $coder = JSON::XS->new->utf8->pretty->allow_nonref;
$coder->canonical([]);

my @objects = qw(tables columns indexes constraints views routines);
my $schema = {};
foreach my $object (@objects) {
    my $rows = $dbh->selectall_hashref($queries->{$object}, 'key_col', undef, $argv->{schema});
    $schema->{$object} = $rows;
}

my $utf8_encoded_json_text = $coder->encode($schema);
open(my $fh, '>', "$argv->{schema}.json") or croak("Can't write file $argv->{schema}.json");
print $fh $utf8_encoded_json_text;
