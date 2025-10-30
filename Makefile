# This enables a shortcut to run a single test from below ./ztests, e.g.:
#  make TEST=TestSPQ/ztests/sqlite/select1/q0
ifneq "$(TEST)" ""
test-one: test-run
endif

test-sqllogic:
	@failed=""; \
	ZTEST_PATH="$(CURDIR)/../super/dist" go test . -v -timeout 6h -count=1 -run TestSPQ/ztests/sqlite/select[1-5] || failed="$${failed}\nsqlite-select"; \
	ZTEST_PATH="$(CURDIR)/../super/dist" go test . -v -timeout 6h -count=1 -run TestSPQ/ztests/sqlite/random/aggregates || failed="$${failed}\nsqlite-random-aggregates"; \
	ZTEST_PATH="$(CURDIR)/../super/dist" go test . -v -timeout 6h -count=1 -run TestSPQ/ztests/sqlite/random/select || failed="$${failed}\nsqlite-random-select"; \
	if [ -n "$$failed" ]; then \
		echo "\nFailed test sets:\n=================$${failed}\n"; \
		exit 1; \
	else \
		echo "All test sets passed!"; \
	fi

test-run:
	@ZTEST_PATH="$(CURDIR)/../super/dist" go test . -v -timeout 6h -count=1 -run $(TEST)
