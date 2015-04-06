##
# GNU Toolchain Definition
#

##
# m.in/toolchain/gnu/program-prefix
# Prefix of some programs of the GNU toolchain.
#
# Default Value:
# null
#
# Usage:
# Some programs of the GNU toolchain can be prefixed depending on how they were
# generated. By default, native programs are not prefixed while
# a cross-compilation toolchain is prefixed by the target.
#
# Example:
# ```
# m.in/toolchain/gnu/program-prefix := powerpc-eabi-
# ```
#
m.in/toolchain/gnu/program-prefix :=

##
# m.in/toolchain/gnu/program-suffix
# Suffix of some programs of the GNU toolchain.
#
# Default Value:
# null
#
# Usage:
# Some programs of the GNU toolchain can be suffixed depending on how they were
# generated. By default, programs are not suffixed.
#
# Example:
# ```
# m.in/toolchain/gnu/program-suffix := -4.9.1
# ```
#
m.in/toolchain/gnu/program-suffix :=

##
# GNU Toolchain Program
# To be completed as soon as needed.
# \{
#

## m.in/toolchain/gnu/bin/rm
m.in/toolchain/gnu/bin/find            = $(m.in/toolchain/gnu/program/find)
m.in/toolchain/gnu/program/find       := find

## m.in/toolchain/gnu/bin/cat
m.in/toolchain/gnu/bin/cat             = $(m.in/toolchain/gnu/program/cat)
m.in/toolchain/gnu/program/cat        := cat

## m.in/toolchain/gnu/bin/cp
m.in/toolchain/gnu/bin/cp              = $(m.in/toolchain/gnu/program/cp)
m.in/toolchain/gnu/program/cp         := cp

## m.in/toolchain/gnu/bin/mkdir
m.in/toolchain/gnu/bin/mkdir           = $(m.in/toolchain/gnu/program/mkdir)
m.in/toolchain/gnu/program/mkdir      := mkdir

## m.in/toolchain/gnu/bin/tar
m.in/toolchain/gnu/bin/tar             = $(m.in/toolchain/gnu/program/tar)
m.in/toolchain/gnu/program/tar        := tar

## m.in/toolchain/gnu/bin/rm
m.in/toolchain/gnu/bin/rm              = $(m.in/toolchain/gnu/program/rm)
m.in/toolchain/gnu/program/rm         := rm

## m.in/toolchain/gnu/bin/nm
m.in/toolchain/gnu/bin/grep            = $(m.in/toolchain/gnu/program/grep)
m.in/toolchain/gnu/program/grep       := grep

## m.in/toolchain/gnu/bin/gcc
define m.in/toolchain/gnu/bin/gcc      =
$(call m.in/toolchain/gnu/program, $(m.in/toolchain/gnu/program/gcc))
endef
m.in/toolchain/gnu/program/gcc        := gcc

##
# m.in/toolchain/gnu/bin/cc
# Default Value:
# gcc
#
m.in/toolchain/gnu/bin/cc              = $(m.in/toolchain/gnu/bin/gcc)

##
# m.in/toolchain/gnu/bin/cpp
# Default Value:
# gcc -E
m.in/toolchain/gnu/bin/cpp             = $(m.in/toolchain/gnu/bin/gcc) -E

## m.in/toolchain/gnu/bin/ld
define m.in/toolchain/gnu/bin/ld       =
$(call m.in/toolchain/gnu/program, $(m.in/toolchain/gnu/program/ld))
endef
m.in/toolchain/gnu/program/ld         := ld

## m.in/toolchain/gnu/bin/ar
define m.in/toolchain/gnu/bin/ar       =
$(call m.in/toolchain/gnu/program,$(m.in/toolchain/gnu/program/ar))
endef
m.in/toolchain/gnu/program/ar         := ar

## m.in/toolchain/gnu/bin/objcopy
define m.in/toolchain/gnu/bin/objcopy  =
$(call m.in/toolchain/gnu/program,$(m.in/toolchain/gnu/program/objcopy))
endef
m.in/toolchain/gnu/program/objcopy    := objcopy

## m.in/toolchain/gnu/bin/strip
define m.in/toolchain/gnu/bin/strip    =
$(call m.in/toolchain/gnu/program,$(m.in/toolchain/gnu/program/strip))
endef
m.in/toolchain/gnu/program/strip      := strip

## m.in/toolchain/gnu/bin/nm
define m.in/toolchain/gnu/bin/nm       =
$(call m.in/toolchain/gnu/program,$(m.in/toolchain/gnu/program/nm))
endef
m.in/toolchain/gnu/program/nm         := nm
## \}

##
# Global Flags
# Use per transaction flags for local flags.
# \{
#

##
# C Preprocessor flags
# Default Value:
# null
#
# Example:
# ```
# m.in/toolchain/gnu/cppflags += -DNDEBUG
# ```
#
m.in/toolchain/gnu/cppflags :=

##
# C Compiler flags
# Default Value:
# null
#
# Example:
# ```
# m.in/toolchain/gnu/cflags += -Wall -Wextra -Werror
# ```
#
m.in/toolchain/gnu/cflags :=

##
# Linker flags
# Default Value:
# null
#
# Example:
# ```
# m.in/toolchain/gnu/ldflags += --fatal-warnings -T $(CWD)kernel.lds
# ```
#
m.in/toolchain/gnu/ldflags :=
## \}

## \}



##
# Toolchain Recipes
# \{
#

##
# m.in/toolchain/gnu/recipe/*/clean
#
define m.in/toolchain/gnu/recipe/*/clean =
$(m.in/toolchain/gnu/bin/rm) -rf $(m.in/clean)
$(m.in/toolchain/gnu/bin/find) . -name '*~' \
  -exec $(m.in/toolchain/gnu/bin/rm) -f {} +
endef

##
# m.in/toolchain/gnu/recipe/*/distclean
#
define m.in/toolchain/gnu/recipe/*/distclean =
$(m.in/toolchain/gnu/bin/rm) -rf $(m.in/distclean)
endef

##
# m.in/toolchain/gnu/recipe/c/dependency
#
define m.in/toolchain/gnu/recipe/c/dependency =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/bin/cc) $(m.in/toolchain/gnu/cppflags)                 \
                             $(call m.in/toolchain/gnu/iflags,$(@:%.d=%.o)) \
                             -MM $< -MT '$@ $(@:%.d=%.o)' -MF $@
endef

##
# m.in/toolchain/gnu/recipe/c/compile(flags?)
# Arguments:
#   flags?
#     optional additional flags
#
define m.in/toolchain/gnu/recipe/c/compile =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/bin/cc) $(m.in/toolchain/gnu/cppflags)       \
                             $(m.in/toolchain/gnu/cflags)         \
                             $(call m.in/toolchain/gnu/iflags,$@) \
                             $1 -c $< -o $@
endef

##
# m.in/toolchain/gnu/recipe/c/preprocess(flags?)
# Arguments:
#   flags?
#     optional additional preprocessor flags
#
define m.in/toolchain/gnu/recipe/c/preprocess =
$(call m.in/toolchain/gnu/recipe/c/compile,-E $1)
endef

#
# m.in/toolchain/gnu/recipe/*/link/template (flags?, objects[])
# Link command template.
#
# Arguments:
#   flags?
#     additional linker flags
#   objects[]
#     objects to link together
#
define m.in/toolchain/gnu/recipe/*/link/template =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/bin/ld) $(m.in/toolchain/gnu/ldflags) $1 -o $@ $2
endef

##
# m.in/toolchain/gnu/recipe/*/link(flags?, head[], tail[])
# Arguments:
#   flags?
#     optional additional preprocessor flags
#   head
#     head list of objects
#   tail
#     tail list of objects
#
define m.in/toolchain/gnu/recipe/*/link =
$(call m.in/toolchain/gnu/recipe/*/link/template,$1,$2 $^ $3)
endef

##
# m.in/toolchain/gnu/recipe/*/archive(flags?)
# Create an archive of objects (aka static library).
#
# Arguments:
#   flags?
#     additional flags
#
define m.in/toolchain/gnu/recipe/*/archive =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/bin/rm) -f $@ && $(m.in/toolchain/gnu/bin/ar) -csr $1 $@ $^
endef

##
# m.in/toolchain/gnu/recipe/*/binary(flags?)
# Create a binary file from any input known by objcopy.
#
# Arguments:
#   flags?
#     additional flags
#
define m.in/toolchain/gnu/recipe/*/binary =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/bin/objcopy) $1 -O binary $< $@
endef
## \}

##
# Toolchain makers
# \{
#

##
# m.in/toolchain/gnu/make_elf(name, flags[]?, head[]?, tail[]?)
# Create an ELF binary file.
#
# Arguments:
#   name
#     binary name
#   flags[]?
#     additional flags
#   head[]?
#     additional head objects
#   tail[]?
#     additional tail objects
#
# Usage:
# ```
# make(elf, example, -Map=example.map)
# ```
#
define m.in/toolchain/gnu/make_elf =
$(call make_explicit, $1,
                      gnu,
                      */link/template,
                      $2,
                      $$(call m.in/transaction/implementations, $1, head) $3
                      $$(call m.in/transaction/implementations,$1, body)
                      $$(call m.in/transaction/implementations,$1, tail) $4)
$(call dependencies_abs, $$$$(m.in/global_dependencies))
endef

##
# m.in/toolchain/gnu/make_object(name, flags[]?)
# Create a raw binary file.
#
# Arguments:
#   name
#     binary name
#   flags[]?
#     additional flags
#   head[]?
#     additional head objects
#   tail[]?
#     additional tail objects
#
# Usage:
# ```
# make(object, example.o)
# ```
#
define m.in/toolchain/gnu/make_object =
$(call m.in/toolchain/gnu/make_elf,$1,-r $2,$3,$4)
endef

##
# m.in/toolchain/gnu/make_binary(name, flags[]?)
# Create a relocatable object.
#
# Arguments:
#   name
#     object name
#   flags[]?
#     additional flags
#
# Usage:
# ```
# make(binary, example.bin)
# ```
#
m.in/toolchain/gnu/make_binary = $(call make_explicit,$1,gnu,*/binary,$2)

##
# m.in/toolchain/gnu/make_archive(name, flags[]?)
# Create an archive, aka static library.
#
# Arguments:
#   name
#     archive name
#   flags[]?
#     additional flags
#
# Usage:
# ```
# make(archive, libexample.a)
# ```
#
m.in/toolchain/gnu/make_archive = $(call make_explicit,$1,gnu,*/archive,$2)
$(eval $(call m.in/debug/trace/1, m.in/toolchain/gnu/make_archive))
##
# m.in/toolchain/gnu/make_library(name, flags[]?)
# Create an archive, aka static library.
#
# Alias:
# `m.in/toolchain/gnu/make_archive()`
#
# Arguments:
#   name
#     archive name
#   flags[]?
#     additional flags
#
# Usage:
# ```
# make(library, libexample.a)
# ```
#
m.in/toolchain/gnu/make_library = $(m.in/toolchain/gnu/make_archive)

## \}

##
# m.in/toolchain/gnu/stdinc
# Standard include paths, i.e. paths to the standard library headers.
#
#
define m.in/toolchain/gnu/stdinc =
$(shell $(m.in/toolchain/gnu/bin/gcc)                               \
          $(subst -nostdinc,,$(m.in/toolchain/gnu/cflags)) -x c     \
          -Wp,-v -E /dev/null 2>&1 | $(m.in/toolchain/gnu/bin/grep) \
          -e '^[^\#]/')
endef

##
# m.in/toolchain/gnu/locate(filename)
# C runtime file path getter.
#
# Arguments:
#   filename
#     file to be located
#
# Usage:
# Explicitly link against standard objects or libraries.
# ```
# libgcc  := $(m.in/toolchain/gnu/locate, libgcc.a)
# libmath := $(m.in/toolchain/gnu/locate, libm.a)
# ```
#
define m.in/toolchain/gnu/locate =
$(strip
  $(shell $(m.in/toolchain/gnu/bin/gcc) $(m.in/toolchain/gnu/cflags) \
          -print-file-name=$(m.in/argv/1))
)
endef


##
# Toolchain's mkdir
# Create a tree of directories or ignore if already present.
# Toolchain definition requirement.
#
m.in/toolchain/gnu/mkdir := $(m.in/toolchain/gnu/bin/mkdir) -p

#
# m.in/toolchain/gnu/program(name)
# Helper macro to prefix and suffix a program `name`.
#
define m.in/toolchain/gnu/program =
$(m.in/toolchain/gnu/program-prefix)$(m.in/argv/1)\
$(m.in/toolchain/gnu/program-suffix)
endef

m.in/toolchain/gnu/program/cat := cat

#
#
#
define m.in/toolchain/gnu/iflags =
$(addprefix $(m.in/toolchain/gnu/iflag),$(call m.in/transaction/interfaces,$(m.in/argv/1)))
endef

#
# Include Flag
# Prefix of transaction interface paths.
#
m.in/toolchain/gnu/iflag := -I
