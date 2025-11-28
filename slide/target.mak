# SPDX-License-Identifier: GPL-3.0-or-later

../slide.tex: license.tex.1 beamer.tex.1 mode.tex.1 \
	      package.tex.1 font.tex.1 title.tex.1 document.tex.1

	awk 'FNR == 1 && NR != 1 { print "" } 1' $^ >$@
