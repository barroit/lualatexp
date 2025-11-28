# SPDX-License-Identifier: GPL-3.0-or-later

AC_INIT([lualatexp], [39])
AC_CONFIG_HEADERS([config.h])
m4_include([helper.m4])

AC_ARG_WITH([profile],
	    [AS_HELP_STRING([--with-profile], [select which profile to load])],
	    [profile=$withval], [profile=""])

case "${profile}" in
slide)
	AC_CONFIG_SUBDIRS([slide])
	;;

math)
	AC_CONFIG_SUBDIRS([math])
	;;
esac

FEATURE([japanese],
	[enable japanese (default)], [Enable Japanese], [yes])

AC_PATH_PROG(CPP, [cpp])
AC_PATH_PROG(M4, [m4])

AC_CONFIG_FILES([config.mak])
AC_OUTPUT
