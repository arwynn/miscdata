.PHONY: ctags clean baseline check

TESTSRC=dradix-test.c hash-test.c slist-test.c clos-test.c

SOURCES=slist.c dradix.c hash.c clos.c hash-test.c dradix-test.c slist-test.c clos-test.c test-suite.c

all: build-tests

build-tests:
	echo "#ifndef __all_tests_h" > t/test-suite.h
	echo "#define __all_tests_h" >> t/test-suite.h
	echo $(TESTSRC)
	cat $(TESTSRC) | egrep -o 'void\s+test_.*\s*\(\s*void\s*\)' | awk '{printf("%s %s;\n",$$1,$$2)}' >> t/test-suite.h
	echo "#endif" >> t/test-suite.h
	gcc -g -Wall $(SOURCES) -o test-suite

ctags:
	ctags *.c

clean:
	rm -f test-suite
	rm -f t/*.h

baseline: build-tests
	./test-suite list 2>&1 | xargs -L 1 t/scripts/mkbaseline.sh

check: build-tests
	./test-suite list 2>&1 | xargs -L 1 t/scripts/checkbaseline.sh

