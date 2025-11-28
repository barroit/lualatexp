# SPDX-License-Identifier: GPL-3.0-or-later

topmake := $(realpath $(lastword $(MAKEFILE_LIST)))

types := slide math

configure-y := $(addsuffix /configure,$(types))
clean-y     := $(addsuffix /clean,$(types))
distclean-y := $(addsuffix /distclean,$(types))

feature-h-y  := $(addsuffix /feature.h,$(types))
feature-m4-y := $(addsuffix /feature.m4,$(types))

tex-y := $(wildcard $(addsuffix /template/*.tex,$(types)))
tex-y := $(subst /template,,$(tex-y))

output-y  := $(addsuffix .tex,$(types))
install-y := $(addsuffix /install,$(types))

subdir-exec  = $(MAKE) -C $$(dirname $@)
recurse-exec = $(subdir-exec) -f $(topmake) $<

-include config.mak

.PHONY: $(clean-y) $(distclean-y) $(tex-y) $(output-y) $(install-y)

$(output-y):

configure: configure.ac
	autoheader
	autoconf

clean:
	rm -f config.mak config.h && \
	rm -f config.log config.status && \
	rm -f feature.h feature.m4 && \
	rm -f *.tex.1 *.tex

distclean: clean
	rm -rf autom4te.cache && \
	rm -f config.h.in && \
	rm -f configure configure~

%.tex.1: feature.m4 template/%.tex
	$(M4) $^ | awk 'NF { p = 1 } p' | tac | awk 'NF { p = 1 } p' | tac >$@

$(prefix):
	mkdir -p $@

$(prefix)/%:
	mkdir $@

$(install-y): %/install: %.tex $(prefix) $(prefix)/image $(prefix)/LICENSES
	>.install-$*

	cp $< $(prefix) && \
	printf '$(prefix)/%s\n' $< >>.install-$*

	cp image/* $(prefix)/image && \
	printf '$(prefix)/%s\n' image/* >>.install-$*

	cp LICENSES/MDM-2.1 $(prefix)/LICENSES && \
	printf '$(prefix)/%s\n' LICENSES/MDM-2.1 >>.install-$*

	cp LICENSES/MPL-2.0 $(prefix)/LICENSES && \
	printf '$(prefix)/%s\n' LICENSES/MPL-2.0 >>.install-$*

feature.h: ../feature.h.in ../config.h config.h
	$(CPP) -P -dD -undef -nostdinc $< | \
	grep -vF -e'#define __STDC_' \
		 -e '#define PACKAGE_' \
		 -e '#undef PACKAGE_' >$@ || true

feature.m4: feature.h
	>$@
	while read drop name val; do >>$@ \
		printf "define(\`%s', \`%s')\n" $$name $$val; \
	done <$<

$(configure-y): %: configure %.ac
	$(recurse-exec)

$(clean-y): clean
	$(recurse-exec)

$(distclean-y): distclean
	$(recurse-exec)

$(tex-y):
	$(subdir-exec) -f $(topmake) $$(basename $@)

$(output-y): %.tex:
	$(MAKE) -C $* -f $(topmake) -f target.mak ../$@
