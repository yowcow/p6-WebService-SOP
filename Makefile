all:
	zef install --/test .

test:
	zef test -v .

.PHONY: all test
