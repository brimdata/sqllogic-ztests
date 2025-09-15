# sqllogic-ztests

This repository is a collection of
[ztests](https://github.com/brimdata/super/blob/main/ztest/ztest.go)
that contain queries derived from
[sqllogictest](https://sqlite.org/sqllogictest/doc/trunk/about.wiki)
scripts. They're intended primarily for use as
[SuperDB](https://github.com/brimdata/super) regression tests.

## Usage

To run all available tests, inside the top-level directory of your SuperDB
checkout:

```
git clone --depth=1 https://github.com/brimdata/sqllogic-ztests
make TEST=TestSPQ/sqllogic-ztests
```

## Details

READMEs inside each subdirectory describe the origin of each set of
tests, with subdirectories below those holding the ztest YAML definitions.

As SuperDB does not yet support SQL [DDL](https://en.wikipedia.org/wiki/Data_definition_language),
each test subdirectory includes a set of input files in
[Parquet](https://parquet.apache.org/) format that the queries treat as
tables. The numeric ztest YAML filenames in each test subdirectory follow the
order of the test queries (i.e., not DDL statements) as they appeared in the
corresponding sqllogictest scripts, e.g., `q0.yaml` is the first query,
`q1.yaml` is the next, etc.
