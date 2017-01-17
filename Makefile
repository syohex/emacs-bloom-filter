.PHONY : test

UNAME_S=$(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	EMACS ?= /Applications/Emacs.app/Contents/MacOS/Emacs
else
	EMACS ?= emacs
endif

LOADPATH = -L .

test:
	$(EMACS) -Q -batch $(LOADPATH) \
		-l test/test.el \
		-f ert-run-tests-batch-and-exit
