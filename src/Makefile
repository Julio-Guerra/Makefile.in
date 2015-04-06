##
# Makefile
#
# Makefile.in is a declarative and highly customizable GNU make library
# allowing you to create configurable builds backed by some of the most
# advanced software engineering techniques such as component-oriented
# programming and interface trees. You will be even able to specialize
# Makefile.in with your own toolchain rules making complex tasks easy and
# productive for you and your team.
# Firstly designed to fit the needs of kernel-development and low-level
# programming, it is now also used to generate web applications.
#
# A file called `Makefile.in` allows you to specify your build, define
# your settings, test your system... You can then run `make` wherever in your
# filesystem: in the root directory (in-source build) or outside it by running
# `make -f /path/to/Makefile`.
# The Makefile is generic and should be read only. It only provides some
# generic rules like `clean`, `distclean`, `all` and the minimum to start the
# framework.
#

##
# MAKEFLAGS
# `make` flags (read-write).
# Deactivate default `make` rules and variables.
#
MAKEFLAGS := --no-builtin-rules --no-builtin-variables

##
# m.in/root
# Project root directory (read-write).
#
# Implementation:
# Get the root directory from `Makefile` location which must be located at
# the project's root. The built-in variable `MAKEFILE_LIST` provides the list
# of files processed, the first one beeing the `Makefile`.
#
m.in/root := $(dir $(firstword $(MAKEFILE_LIST)))

##
# m.in/mk_prefix
# Makefile.in framework directory (read-write).
#
m.in/mk_prefix := $(m.in/root)mk

##
# all
# Default target.
# Make everything.
#
.PHONY: all
all:

#
# Makefile.in core library.
#
include $(m.in/mk_prefix)/core/core.mk

##
# Makefile.in
#
$(eval $(call include, Makefile.in))

##
# clean
# Remove every intermediate files created to generate leaf targets.
# This rule cannot be run in parallel of others (i.e. of targets
# generating files beeing at the same time deleted).
#
.PHONY: clean
.NOTPARALLEL: clean
$(eval $(call m.in/rule, clean:, , */clean))

##
# distclean
# Remove every generated files but empty directories generated during
# the build.
#
.PHONY: distclean
.NOTPARALLEL: distclean
$(eval $(call m.in/rule, distclean: clean, , */distclean))

##
# m.in/version
# Print Makefile.in version.
#
.PHONY: m.in/version
m.in/version:
	@echo "$(m.in/term/tag/info) version: $(m.in/version)"
