##
# Makefile.in environment bootstrap.
# \{
#

##
# m.in/version
# Makefile.in version.
#
m.in/version             := 1-alpha

##
# m.in/mk/library
# Makefile.in public API file, built on top of the following definitions.
#
m.in/mk/library          := $(m.in/mk_prefix)/library.mk

##
# m.in/lang_prefix
# Directory of languages.
#
m.in/lang_prefix         := $(m.in/mk_prefix)/lang

##
# m.in/toolchain_prefix
# Directory of toolchains.
#
m.in/toolchain_prefix    := $(m.in/mk_prefix)/toolchain

##
# m.in/toolchain
# Default toolchain that will be used by automatic macros like `add()`...
#
m.in/toolchain           := gnu

##
# m.in/core_prefix
# Directory of core library.
#
m.in/core_prefix         := $(m.in/mk_prefix)/core

##
# m.in/mk/core/terminal
# Terminal management library.
#
m.in/mk/core/terminal    := $(m.in/core_prefix)/terminal.mk

##
# m.in/mk/core/transaction
# Transaction management library.
#
m.in/mk/core/transaction := $(m.in/core_prefix)/transaction.mk

##
# m.in/mk/core/component
# Component management library.
#
m.in/mk/core/component   := $(m.in/core_prefix)/component.mk

##
# m.in/mk/core/misc
# Misc library.
#
m.in/mk/core/misc       := $(m.in/core_prefix)/misc.mk

##
# m.in/mk/core/debug
# Debug library.
#
m.in/mk/core/debug      := $(m.in/core_prefix)/debug.mk

##
# m.in/mk/core
# Core library.
#
m.in/mk/core            := $(m.in/mk/core/debug)       \
                           $(m.in/mk/core/misc)        \
                           $(m.in/mk/core/transaction) \
                           $(m.in/mk/core/component)   \
                           $(m.in/mk/core/terminal)

## \}

#
# Core libraries.
#
include $(m.in/mk/core)

##
# Makefile.in core library
# Low-level Makefile.in library to build a better world.
# Users should not directly use these macros but library.mk's.
#
# \{
#

##
# m.in/prefix
# Current project prefix (read-only).
# Smallest common prefix path of included directories/files with
# `m.in/include`. So including a path/file outside current prefix
# will result in a new prefix.
# Note that `m.in/prefix` is not necessarily absolute. It depends on the
# way you called the Makefile: `make -f /path/to/Makefile` will result
# in `m.in/prefix = /path/to/` whereas `make -f ../Makefile` will result
# to `m.in/prefix = ../`.
#
# Implementation:
# Top of the prefix stack, i.e. last prefix directory where the file was
# included from. Root directory when the stack is empty.
# See also `m.in/include()`
#
m.in/prefix = $(or $(call m.in/stack/peek, m.in/prefix/stack), $(m.in/root))

##
# m.in/cwd
# Current working directory (read-only).
# Same as `CWD`.
#
# Implementation:
# Top of include stack, i.e. last prefix directory of the file included.
#
m.in/cwd = $(or $(call m.in/stack/peek, m.in/include/stack), $(m.in/prefix))

##
# m.in/cbd
# Current build directory (read-only).
# Same as `CBD` but without leading `./`. This is for internal usage only
# where the leading `./` is not always used, so that it can be added
# when necessary.
#
# Implementation:
# Top of include stack, i.e. last prefix directory of the file included.
# See also `m.in/include()`.
#
m.in/cbd = $(strip $(patsubst $(m.in/prefix)%, %, $(m.in/cwd)))

##
# m.in/out_of_source
# Out-of-source build (read-only).
# True (non-empty string) when an out-of-source build is performed.
#
# Implementation:
# True when current build directory is not relative to the root directory.
#
define m.in/out_of_source :=
$(if $(filter $(abspath $(m.in/root)), $(abspath ./$(m.in/cbd))),,t)
endef

##
# m.in/ignore_dynamic_dependencies
# List of rules ignoring dynamic dependencies generation (read-write).
# Rules not requiring computing dynamic dependencies.
#
m.in/ignore_dynamic_dependencies := clean distclean

##
# m.in/global_dependencies
# Global dependencies (read-write).
# Dependency list that should impact every targets.
# A good tracking of target dependencies avoids executing clean/distclean
# targets to regenerate everything.
# Makefiles are such dependencies since they define how to generate targets:
# modifying one should invalidate every targets.
#
m.in/global_dependencies = $(filter-out %.d, $(MAKEFILE_LIST))

##
# m.in/clean
# Default clean list.
#
m.in/clean = .m.in

##
# m.in/clean
# Default distclean list.
#
m.in/distclean =

##
# m.in/tracker(name)
# Return a tracker filename to track commands whose result is not a file
# that can tracked by make.
#
define m.in/tracker =
.m.in/tracker/$(m.in/argv/1)
endef

##
# m.in/make_implicit(file)
# See `make_implicit()`.
#
# Implementation:
# add the target to the distclean list.
# create and start a new transaction.
# add the target to the target list.
#
define m.in/make_implicit =
m.in/distclean += $(m.in/argv/1)
m.in/clean      = $(filter-out $(m.in/distclean), $(value m.in/clean))
$(call m.in/transaction/create, $(m.in/argv/1))
all : $(m.in/argv/1)
endef
$(eval $(call m.in/debug/trace/1, m.in/make_implicit))

##
# m.in/make_explicit(file, toolchain?, recipe, args...?)
# See `m.in/make_explicit()`.
#
# Arguments:
#  file
#    Target file to be generated.
#  toolchain?
#    Toolchain to use for the recipe.
#  recipe
#    Target creation recipe.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define m.in/make_explicit =
$(call m.in/make_implicit, $(m.in/argv/1))
$(call m.in/rule, $(m.in/argv/1) :,
                  $(strip $2),
                  $(m.in/argv/3),
                  $(strip $4),
                  $(strip $5),
                  $(strip $6),
                  $(strip $7),
                  $(strip $8),
                  $(strip $9),
                  $(strip $(10)),
                  $(strip $(11)),
                  $(strip $(12)),
                  $(strip $(13)))
endef

##
# m.in/make(helper, file, args...?)
#
#
define m.in/make =
$(call m.in/assert,
  $(value m.in/toolchain/$(m.in/toolchain)/make_$(m.in/argv/1)),
  the toolchain $(call m.in/term/vfx/sexy, $(m.in/toolchain)) doest not provide
  $(call m.in/term/vfx/sexy, make_$(m.in/argv/1)))
$(call m.in/toolchain/$(m.in/toolchain)/make_$(m.in/argv/1),$(m.in/argv/2),$3,$4,$5,$6,$7,$8,$9)
endef
$(eval $(call m.in/debug/trace/1, m.in/make))

##
# m.in/prerequisites(position, files[])
# See `prerequisities()`.
#
# Implementation:
# add the list to the target dependencies.
# for each file, save required interfaces.
#
define m.in/prerequisites =
$(call m.in/dependencies, $(m.in/argv/2))
$(call m.in/transaction/implementations/add, $(m.in/transaction/current),
                                             $(m.in/argv/1),
                                             $(m.in/argv/2))
$(foreach f, $(m.in/argv/2), $(if $(call m.in/transaction/is_created, $f),, $(call m.in/transaction/inherit, $f, $(m.in/transaction/current))))
m.in/clean += $(filter-out $(m.in/distclean), $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/1, m.in/prerequisites))

##
# dependencies(files[])
# See `dependencies()`.
#
# Arguments:
#  files[]
#    List of target dependencies.
#
# precondition: transaction created
# add the list to target's dependencies.
#
define m.in/dependencies =
$$(call m.in/assert, $$(m.in/transaction/current), \
  $0 must be called within the context of a transaction)
.SECONDEXPANSION:
$$(m.in/transaction/current) : $(m.in/argv/1)
endef
$(eval $(call m.in/debug/trace/1, m.in/dependencies))

##
# provide_abs(component, interfaces[], dependencies[])
# See `provide()`
#
define m.in/provide =
$(call m.in/component/interfaces/add,
  $(m.in/argv/1),
  $(call m.in/component/prefix,
    $(m.in/argv/1),
    $(m.in/argv/2)))
$(and $(strip $3),
  $(call m.in/component/interfaces/dependencies/add, $(m.in/argv/1),
                                                     $(m.in/argv/3)))
$(call m.in/component/build/set,
  $(m.in/argv/1),
  $(if $(call m.in/is_root_subdir, $(m.in/cwd)), ./, $(m.in/prefix)))
endef
$(eval $(call m.in/debug/trace/1, m.in/provide))

##
# (position, component, args...?)
# (position,          , interfaces[])
#
define m.in/require =
$(call m.in/assert,
  $(call m.in/transaction/is_created, $(m.in/transaction/current)),
  transaction not created)
$(call m.in/transaction/interfaces/add,
  $(m.in/transaction/current),
  $(m.in/argv/1),
  $(if $(strip $2),
    $$(call m.in/expand, $$(call m.in/component/interfaces, $(m.in/argv/2)),
                         $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12)),
    $(m.in/argv/3)))
$(and $(strip $2),
  $(call m.in/component/interfaces/dependencies/value, $(m.in/argv/2)),
  $(foreach d,                                                      \
    $(call m.in/component/interfaces/dependencies, $(m.in/argv/2)), \
    $(call m.in/require, $(m.in/argv/1), $d)))
endef

##
# m.in/implement(component, paths[], dependencies[])
#
define m.in/implement =
$(call m.in/component/implementations/add,$(m.in/argv/1),$(call m.in/component/prefix,$(m.in/argv/1),$(m.in/argv/2)))
$(and $(strip $3),
  $(call m.in/component/implementations/dependencies/add, $(m.in/argv/1), $(m.in/argv/3)))
$(call m.in/component/build/set,$(m.in/argv/1),$(if $(call m.in/is_root_subdir,$(m.in/cwd)),./,$(m.in/prefix)))
endef
$(eval $(call m.in/debug/trace/1, m.in/implement))

##
# m.in/link(position, component, args...?)
# m.in/link(position,          , objects)
#
define m.in/link =
$(if $(strip $2),
  $(call m.in/dependencies,
    $$$$(call m.in/expand,
         $$$$(call m.in/component/implementations, $(m.in/argv/2)),
         $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12)))
  $(call m.in/transaction/implementations/add,
    $(m.in/transaction/current),
    $(m.in/argv/1),
    $$(call m.in/expand,
       $$(call m.in/component/implementations, $(m.in/argv/2)),
       $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12)))
  $(and
    $(call m.in/component/implementations/dependencies/value, $(m.in/argv/2)),
    $(foreach d,                                                           \
      $(call m.in/component/implementations/dependencies, $(m.in/argv/2)), \
      $(call m.in/link, $(m.in/argv/1), $d))),

  $(call m.in/dependencies, $(m.in/argv/3))
  $(call m.in/transaction/implementations/add, $(m.in/transaction/current),
                                               $(m.in/argv/1),
                                               $(m.in/argv/3))
)
endef

define m.in/include =
$(eval $(call m.in/stack/push, m.in/include/stack, $(dir $(m.in/argv/1))))
$(if
  $(call m.in/is_subdir,
    $(or $(call m.in/stack/at, m.in/include/stack, 2), ./), $(m.in/cwd)),,
  $(eval $(call m.in/stack/push, m.in/prefix/stack, $(dir $(m.in/argv/1)))))
$(m.in/transactions/save)
include $(m.in/argv/1)
$(m.in/transactions/restore)
$(if
  $(call m.in/is_subdir,
    $(or $(call m.in/stack/at, m.in/include/stack, 2), ./), $(m.in/cwd)),,
  $(call m.in/stack/pop, m.in/prefix/stack))
$(call m.in/stack/pop, m.in/include/stack)
endef
$(eval $(call m.in/debug/trace/1, m.in/include))

##
# m.in/rule(rule, toolchain?, recipe, args...?)
# Define a makefile new production rule based on the recipe of a toolchain.
#
# Arguments:
#  rule
#    Makefile rule in the form `target: prerequisities`.
#  toolchain?
#    Toolchain to use for the recipe.
#  recipe
#    Target creation recipe.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define m.in/rule =
.SECONDEXPANSION:
$(m.in/argv/1)
	@echo                                                                       \
     "$$(call m.in/term/vfx/$$(if $$(call m.in/is_prereq, $$@),prereq,target),\
         $(or $(strip $2), $$(m.in/toolchain))/$(m.in/argv/3)) $$@"
	$$(call m.in/expand, $$(call m.in/toolchain/recipe,            \
                          $(or $(strip $2), $$(m.in/toolchain)), \
                          $(m.in/argv/3)),                       \
                        $(strip $4),                             \
                        $(strip $5),                             \
                        $(strip $6),                             \
                        $(strip $7),                             \
                        $(strip $8),                             \
                        $(strip $9),                             \
                        $(strip $(10)),                          \
                        $(strip $(11)),                          \
                        $(strip $(12)),                          \
                        $(strip $(13)))
endef
#$(eval $(call m.in/debug/trace/1, m.in/rule))

##
# m.in/add(sources[], position, args...?)
# Add each provided file to current transaction. Each file must have an
# extension and a language extension must provide a
# `m.in/lang/add.<file-extension>` macro. Since file extensions are global,
# only one language can use it. The recipe is selected according to the files'
# extensions by calling `m.in/lang/add.<file-extension>`.
#
# Arguments:
#  sources[]
#    List of file sources to be added to current transaction.
#  position
#    Relative insertion position into the transaction.
#    See `m.in/transaction/*`.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define m.in/add =
$(foreach f, $(m.in/argv/1),                                            \
  $(or                                                                  \
    $(call m.in/lang/add$(suffix $f), $(m.in/argv/2),                   \
                                      $(strip $f),
                                      $(strip $3),
                                      $(strip $4),
                                      $(strip $5),
                                      $(strip $6),
                                      $(strip $7),
                                      $(strip $8),
                                      $(strip $9),
                                      $(strip $(10)),
                                      $(strip $(11)),
                                      $(strip $(12))),                  \
    $(call m.in/error, filename extension `$(suffix $f)` not supported: \
                       undefined macro `m.in/lang/add$(suffix $f)`))
)
endef
$(eval $(call m.in/debug/trace/1, m.in/add))

##
# m.in/toolchain/recipe(toolchain, recipe, args...?)
# Call a recipe of a toolchain. The recipe must be defined by the toolchain
# into `m.in/toolchain/<toolchain-name>/recipe/<recipe-name>`.
#
# Arguments:
#  toolchain
#    Toolchain name.
#  recipe
#    Recipe name.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define m.in/toolchain/recipe
$(or $(value m.in/toolchain/$(m.in/argv/1)/recipe/$(m.in/argv/2)),  \
     $(call m.in/error, the toolchain $(m.in/argv/1) does not define the recipe
                        $(m.in/argv/2)))
endef
$(eval $(call m.in/debug/trace/3, m.in/toolchain/recipe))

##
# m.in/include_dynamic_dependency(dependency)
# Include the dependency file only if required and append it to the
# clean list. This macro only must be used with dynamically created files.
# Rules not requiring dynamic dependencies must be listed in `NODEPS_`.
#
# Arguments:
#  dependency
#    Dependency file.
#
define m.in/include_dynamic_dependency =
ifeq ($$(filter $$(m.in/ignore_dynamic_dependencies), $$(MAKECMDGOALS)),)
-include $(m.in/argv/1)
endif
m.in/clean += $(m.in/argv/1)
endef
$(eval $(call m.in/debug/trace/3, m.in/include_dynamic_dependency))

##
# m.in/is_prereq(file)
# Determine if `file` is only a prerequisite.
# See `m.in/rule()`.
#
# Several ways can be imagined to determine if a target is intermediate
# or not. We simply check `file` is in `m.in/clean` variable.
#
define m.in/is_prereq =
$(filter $(m.in/argv/1),$(m.in/clean))
endef
$(eval $(call m.in/debug/trace/3, m.in/is_prereq))

##
#
#
m.in/is_root_subdir = $(call m.in/is_subdir, $(m.in/root), $(m.in/argv/1))
$(eval $(call m.in/debug/trace/3, m.in/is_root_subdir))

##
# m.in/mkdir(directory)
# Out-of-source builds need creation of output directories.
# Trying to build things out of the project directory is considered
# ill-formed.
#
define m.in/mkdir =
$(call m.in/assert,$(m.in/toolchain/$(m.in/toolchain)/mkdir),             \
  The toolchain does not provide $(call m.in/term/vfx/sexy,mkdir))
$(call m.in/assert,$(call m.in/is_subdir, ./$(m.in/cbd), $(m.in/argv/1)), \
  Creating a directory outside of the project is forbidden.               \
  $(call m.in/term/vfx/sexy, $(m.in/argv/1)) is not relative to           \
  $(call m.in/term/vfx/sexy, ./$(m.in/cbd)))
$(m.in/toolchain/$(m.in/toolchain)/mkdir) $(m.in/argv/1)
endef
$(eval $(call m.in/debug/trace/3, m.in/mkdir))

# User API
include $(m.in/mk/library)

# Toolchains
include $(m.in/toolchain_prefix)/*
# Languages
include $(m.in/lang_prefix)/*

$(eval $(m.in/debug/trace/install))

## \}
