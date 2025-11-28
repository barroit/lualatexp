# SPDX-License-Identifier: GPL-3.0-or-later

prefix ?= build
name   ?= slide

input  := $(name).tex
alias  := $(name).pdf
output := $(prefix)/$(alias)

$(output):

$(prefix):
	mkdir -p $@

$(alias): $(prefix)
	ln -s $(output) $@

$(output): $(prefix) $(input) $(alias)
	lualatex --output-directory=$(prefix) --jobname=$(name) $(input)
