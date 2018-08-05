all:
	zef install --deps-only --/test .

test:
	zef test -v .

.PHONY: all test
