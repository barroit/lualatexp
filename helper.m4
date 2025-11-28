# SPDX-License-Identifier: GPL-3.0-or-later

m4_define([FEATURE],
[
	AC_ARG_ENABLE([$1], [AS_HELP_STRING([--enable-$1], [$2])],
		      [use_$1=$enableval], m4_ifval([$4], [[use_$1=$4]]))

	AS_IF([test "x$use_$1" = "xyes"],
	      [AC_DEFINE(m4_toupper([USE_$1]), [1], [$3])])
])
