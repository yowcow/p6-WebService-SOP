all:

test:
	prove -e 'perl6 -Ilib' -r t

.PHONY: all test
