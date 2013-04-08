all: parser.js

test: parser.js parser_test.coffee
	coffee parser_test.coffee

parser.js: parser.pegjs
	pegjs $< $@

.PHONY: all test
