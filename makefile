.PHONY: all clean test

ZEL_HOST ?= emacs -Q --batch

ZEL := ZEL_HOST="$(ZEL_HOST)" ./zel

MODS := zel.el \
	zel-test.el

all: $(MODS:.el=.elc)

clean:
	@rm -f *.elc

%.elc : %.el
	@echo "  $@"
	@echo "$<" | ZEL_CODE=" " $(ZEL) -f byte-compile-file

test: all
	@$(ZEL) -l zel-test -f zel-run-tests
