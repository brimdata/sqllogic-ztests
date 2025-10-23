# This enables a shortcut to run a single test from below ./ztests, e.g.:
#  make TEST=TestSPQ/ztests/sqlite/select1/q0
ifneq "$(TEST)" ""
test-one: test-run
endif

test-sqllogic:
	@ZTEST_PATH="$(CURDIR)/../super/dist" go test -v -count=1 .

test-run:
	@ZTEST_PATH="$(CURDIR)/../super/dist" go test . -v -count=1 -run $(TEST)
