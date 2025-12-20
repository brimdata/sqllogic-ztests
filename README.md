# sqllogic-ztests

This repository is a collection of
[ztests](https://github.com/brimdata/super/blob/main/ztest/ztest.go)
that contain queries derived from
[sqllogictest](https://sqlite.org/sqllogictest/doc/trunk/about.wiki)
scripts. They're intended primarily for use as
[SuperDB](https://github.com/brimdata/super) regression tests.

## Usage

Checkout this repo as a sibling directory alongside your checkout of the
[super repo](https://github.com/brimdata/super), e.g.:

```
$HOME/sqllogic-ztests
$HOME/super
```

Then within the checkout for this repo, do:

```
make test-sqllogic
```

That will run all sqllogictests below `ztests/` using the last built binary at
`dist/super` in your super repo checkout.

You can also run just a single sqllogic ztest, e.g.:

```
make TEST=TestSPQ/ztests/sqlite/select1/q0
```

or groups of ztests by directory, e.g.:

```
make TEST=TestSPQ/ztests/sqlite/select[1-5]
```

In fact, that last one may prove handy if you want a quick "smoke test" on a
super branch, since those ~5000 tests run in just a few minutes and provide a
decent regression suite. Meanwhile, if you run 100% of the available tests
you'll also get the 3+ million fuzz-style ztests below `sqlite/random/select/`,
which do provide wider coverage but also take hours to complete.

## Details

READMEs inside each `ztests/` subdirectory describe the origin of each set of
tests, with subdirectories below those holding the ztest YAML definitions.

As SuperDB does not yet support SQL [DDL](https://en.wikipedia.org/wiki/Data_definition_language),
each test subdirectory includes a set of input files in
[Parquet](https://parquet.apache.org/) format that the queries treat as
tables. The numeric ztest YAML filenames in each test subdirectory follow the
order of the test queries (i.e., not DDL statements) as they appeared in the
corresponding sqllogictest scripts, e.g., `q0.yaml` is the first query,
`q1.yaml` is the next, etc.

The modifications in [`super.patch`](super.patch) must currently be applied
to your checkout of the super repo before doing `make build`.

```
patch -d super -p1 < sqllogic-ztests/super.patch
make -C super build
```

This is a temporary fix to produce TSV output from `super` that is `diff`-able
against the expected sqllogictest outputs. Patching will not be necessary once
[super/5961](https://github.com/brimdata/super/issues/5961) and
[super/6381](https://github.com/brimdata/super/issues/6381) are addressed.

## Improving Git Performance

Since there's 3+ million files in this repo, local Git operations on its 
contents can be painfully slow. To improve on this, it's been found that
executing the following inside your local clone of the repo may improve things
significantly:

```
git config feature.manyFiles true
git config core.fsmonitor true
git fsmonitor--daemon start
git maintenance run
```

On my Intel-based Macbook, this brings the time to run `git status` down from
~40 seconds to ~1 second.

More notes regarding these commands:

* For the `core.fsmonitor true` config to have effect, that
  [`fsmonitor--daemon`](https://git-scm.com/docs/git-fsmonitor--daemon) must be
  running, which monitors the working directory for changes.

* The `git maintenance run` is a "one shot" optimization pass, so should be
  re-run periodically to get the best possible performance.
