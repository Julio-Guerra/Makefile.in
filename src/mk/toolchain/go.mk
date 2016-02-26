##
# Go Toolchain Programs
# Based of GNU's
# \{
#


##
# m.in/toolchain/go/program-prefix
# Prefix of programs of the Go toolchain.
#
# Default Value:
# null
#
# Usage:
# - docker run ... :)
# - Programs can be prefixed depending on how they were generated.
#   By default, native programs are not prefixed while a cross-compilation
#   toolchain is prefixed by its target.
#
m.in/toolchain/go/program-prefix :=

##
# m.in/toolchain/gnu/program-suffix
# Suffix of programs of the Go toolchain.
#
# Default Value:
# null
#
# Usage:
# Some programs can be suffixed depending on how they were generated. By
# default, programs are not suffixed.
#
m.in/toolchain/go/program-suffix :=

##
# m.in/toolchain/go/program(name)
# Helper macro to prefix and suffix a program `name`.
#
define m.in/toolchain/go/program =
$(strip
$(m.in/toolchain/go/program-prefix)$(m.in/argv/1)\
$(m.in/toolchain/go/program-suffix))
endef


##
# GNU Toolchain Program
# To be completed as soon as needed.
# \{
#

## m.in/toolchain/go/bin/go
define m.in/toolchain/go/bin/go =
$(call m.in/toolchain/go/program, $(m.in/toolchain/go/program/go))
endef
m.in/toolchain/go/program/go   := go

## \}


##
# Global Flags
# \{
#

##
# Go command option flags.
# Default Value:
# null
#
# Example:
# ```
# m.in/toolchain/go/goflags := -v -x
# ```
#
m.in/toolchain/go/goflags :=

## \}

##
# Toolchain Recipes
# \{
#

##
# m.in/toolchain/go/recipe/go/build(flags?)
# Build packages. Flags may be optionally added for this recipe, along
# with global flags `m.in/toolchain/go/goflags`.
#
define m.in/toolchain/go/recipe/build =
$(m.in/toolchain/go/bin/go) build $(m.in/toolchain/go/goflags) -o $@ $(strip $1) \
                            $(call m.in/transaction/implementations, $@)
endef

##
# m.in/toolchain/go/recipe/go/test(flags?)
# Test packages. Flags may be optionally added to the recipe, along
# with global flags `m.in/toolchain/go/goflags`.
#
define m.in/toolchain/go/recipe/test =
$(m.in/toolchain/go/bin/go) test $(m.in/toolchain/go/goflags) $(strip $1) \
                            $(call m.in/transaction/implementations, $@)
endef

##
# m.in/toolchain/go/recipe/go/tool(tool, args?)
# Call a go tool command `tool` with given `args`.
#
define m.in/toolchain/go/recipe/tool =
$(m.in/toolchain/go/bin/go) tool $(m.in/argv/1) $(strip $2)
endef


## m.in/toolchain/go/recipe/*/clean
m.in/toolchain/go/recipe/*/clean = $(m.in/toolchain/gnu/recipe/*/clean)

## m.in/toolchain/go/recipe/*/distclean
m.in/toolchain/go/recipe/*/distclean = $(m.in/toolchain/gnu/recipe/*/distclean)

## \}

##
# Toolchain Makers
# \{
#

##
# m.in/toolchain/go/make_build(target, flags?)
# Build a go package.
#
define m.in/toolchain/go/make_build =
$(call make_explicit, $1, go, build, $2)
$(call dependencies_abs, $$$$(m.in/global_dependencies))
endef

##
# m.in/toolchain/go/make_test(target, flags?)
# Create a phony target `target` which calls `go test` on current transaction's
# implementations. Optional `go test` flags can be provided.
#
define m.in/toolchain/go/make_test =
$(call make_phony, $(m.in/argv/1), go, test, $2)
endef

##
# m.in/toolchain/go/make_tool(tool, args...?)
# Call a go tool.
#
define m.in/toolchain/go/make_tool =
$(call make_phony, $(m.in/argv/1),
                   go,
                   tool,
                   $(m.in/argv/1),
                   $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

## \}
