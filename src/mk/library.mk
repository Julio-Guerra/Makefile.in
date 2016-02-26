##
# Makefile.in API.
# Set of functions to specify your build requirements.
# By default, paths you provide are relative to your working directory unless
# the absolute version of the function is used, in which case you are free to
# specify the prefix.
#
# Basically three modes can be used mixed:
# - Managed: fully managed by the toolchain stating what you have.
#   This is the recommended mode since it is the easiest.
#   See `make()` and `add()`.
#
# - Implicit
#   Managed by extension names (.c, .js, .S, etc.) stating what you want.
#   This mode used `make_implicit()` and requires a language backend.
#   See `make_implicit()`.
#
# - Explicit: most explicit mode which requires you to specify the rule and
#   toolchain to be used to generate your target.
#   See `make_explicit()`.
#
# Every macro is by default relative to the directory where they are used.
# Absolute versions are simply not automatically prefixed by
# `$(CBD)`.
#
# \{
#

##
# CWD
# Current Working Directory (read-only).
# Path leading to the working directory (i.e. where currently edited file is,
# where the variable is used) from the current build directory `$CBD`.
# Note CWD is terminated by '/'.
#
# Usage:
# Refer to source files.
#
CWD = $(m.in/cwd)

##
# CBD
# Current Build Directory (read-only).
# Read-Only variable.
# Path leading to the working build directory. CBD differs from CWD when an
# out-of-source build is performed.
# Note CBD is terminated by '/'.
#
# Usage:
# Refer to generated files.
#
CBD = ./$(m.in/cbd)

##
# make_phony(target, toolchain?, recipe, args?)
# Define a new phony target explicitly using `recipe` with given optional
# `args` of `toolchain` and create a new transaction.
# A phony target is not tracked by distclean nor added as dependency of the
# default `all` target. Such targets should be called manually.
#
# Arguments:
#  target
#    Phony target.
#  toolchain?
#    Toolchain identifier used to select the recipe.
#  recipe
#    Target creation recipe.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define make_phony =
$(call m.in/transaction/create, $(m.in/argv/1))
.PHONY: $(m.in/argv/1)
$(call m.in/rule, $(m.in/argv/1):,
                  $2,
                  $(m.in/argv/3),
                  $4, $5, $6, $7, $8, $9, $(10), $(11), $(12), $(13))
endef

##
# make_implicit(file)
# Define a new target to generate `file` and start a new transaction.
# The underlying rule is selected based on the file extension - a language
# must provide such a rule.
#
# Arguments:
#  file
#    file to be generated.
#
define make_implicit =
$(call m.in/make_implicit, $(addprefix $(m.in/cbd), $(m.in/argv/1)))
endef

##
# prerequisities(files[])
# Add files to the prerequisities list of current target transaction.
# Prerequisities are files to be generated first to make the target
# generation possible. Each prereq will hence inherit from current
# interface requirements settings.
# The underlying rule is selected based on the file extension - a language
# must provide such a rule.
#
prerequisites             = $(prerequisites_body)
prereq                    = $(prerequisites)
define prerequisites_body =
$(call prerequisites_abs_body,$(addprefix $(m.in/cbd), $(m.in/argv/1)))
endef


define prerequisites_head =
$(call prerequisites_abs_head,$(addprefix $(m.in/cbd), $(m.in/argv/1)))
endef

define prerequisites_tail =
$(call prerequisites_abs_tail,$(addprefix $(m.in/cbd), $(m.in/argv/1)))
endef

##
# prerequisites_abs(files[])
# See `prerequisities()`.
#
# Arguments:
#  files[]
#    List of target prerequisities.
#
#
prerequisites_abs      = $(prerequisites_abs_body)
prereq_abs             = $(prerequisites_abs)
prerequisites_abs_head = $(call m.in/prerequisites,head, $(m.in/argv/1))
prerequisites_abs_body = $(call m.in/prerequisites,body, $(m.in/argv/1))
prerequisites_abs_tail = $(call m.in/prerequisites,tail, $(m.in/argv/1))

##
# dependencies_abs(files[])
# Add files the dependency list of current target transaction.
# Any file impacting the generation of current transaction should be listed
# in target's dependencies.
#
# Arguments:
#  files[]
#    List of target dependencies.
#
#
dependencies_abs = $(m.in/dependencies)

##
# dependencies(files[])
# See `dependencies_abs()`.
#
define dependencies =
$(call dependencies_abs,$(addprefix $(m.in/cwd), $(m.in/argv/1)))
endef

##
# make_explicit(file, toolchain?, recipe, args...?)
# Define a new target to generate `file` explicitly using `recipe`.
# Unlike `target()`, the underlying rule is not selected based on the file
# extension.
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
define make_explicit =
$(call m.in/make_explicit, $(addprefix $(m.in/cbd), $(m.in/argv/1)),
                           $2,
                           $(m.in/argv/3),
                           $4, $5, $6, $7, $8, $9, $(10), $(11), $(12), $(13))
endef

##
# make(helper, file, args...?)
# Toolchain-managed target generation using current toolchain's
# `make_<helper>()` macro.
#
# Arguments:
#  helper
#    Helper
#  file
#    Target file to be generated.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#
define make =
$(call m.in/make, $(m.in/argv/1),
                  $(m.in/argv/2),
                  $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12))
endef

##
# add(sources[], args...?)
# Toolchain-managed target sources. Add source `file` to current transaction's
# body according to the toolchain-supplied `add` macro. It allows a higher
# level of abstraction by making possible adding any kind (i.e. extension)
# of file as long as the selected toolchain `m.in/toolchain` defines
# `add.<extension>()`. Files added with this macro must be in the source-tree.
#
# Example:
# ```
# make(elf, myprogram)
# add(myobj.o main.c mylib.a)
# ```
#
# Prefer using components to link against implementations instead of `add()`.
#
# Arguments:
#  sources[]
#    List of file sources to be added to current transaction.
#  args...?
#    Recipe arguments. Optional according to the recipe specification.
#    The recipe is selected according to the files' extensions by calling
#    `m.in/lang/add.<file-extension>`.
#
define add =
$(call m.in/add, $(m.in/argv/1),
                 body,
                 $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

##
# add_tail(sources[], args...?)
# Add `file` to current transaction's tail.
# See `add()`.
#
define add_tail =
$(call m.in/add, $(m.in/argv/1),
                 tail,
                 $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

##
# add_head(sources[], args...?)
# Add `file` to current transaction's head.
# See `add()`.
#
define add_head =
$(call m.in/add, $(m.in/argv/1),
                 head,
                 $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

##
# include(path)
# See `include_abs()`.
#
include = $(call include_abs, $(m.in/cwd)$(m.in/argv/1))

##
# include_abs(path)
# Include a makefile file.
# `$(m.in/cwd)` and `$(CBD)` variables will be updated accordingly.
# Transactions created in `path` will be automatically terminated when leaving
# `path` directory.
#
# Arguments:
#  path
#    Subdirectory or file path with a `.in` or `.mk` suffix.
#
# Usage:
# - Split complex projects into subdirectories.
# - Split complex components into subcomponents.
# ```
# # Makefile.in
# $(eval $(call make,elf,example.elf))
# $(eval $(call include,src))
# # Custom submakefile names. External component declarations
# $(eval $(call include_abs,/external/component/Library.in))
# $(eval $(call link,subcomponent1))
# $(eval $(call link,subcomponent2))
# $(eval $(call link,external_component))
# ```
# ```
# # src/Makefile.mk
# $(eval $(call include,subcomponent1))
# $(eval $(call include,subcomponent2))
# ```
# ```
# # /external/component/Library.in
# $(eval $(call implement,external_component,lib/libexternal_component.a))
# ```
#
define include_abs =
$(call m.in/include, $(or $(filter %.mk %.in, $(m.in/argv/1)), \
                          $(m.in/argv/1)/Makefile.mk))
endef

##
# provide_abs(component, interfaces[], dependencies[])
# See `provide()`
#
provide_abs = $(m.in/provide)

##
# provide(component, interfaces[], dependencies[])
#
define provide =
$(call provide_abs, $(m.in/argv/1),
                    $(addprefix $(m.in/cwd), $(m.in/argv/2)),
                    $3)
endef

##
# require(component, args...?)
# Require the given component by adding its include path to the
# current working directory and subdirectories include search paths of
# current transaction.
#
# Arguments:
#
require             = $(require_body)
define require_body =
$(call require_abs_body,
  $1,
  $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $(strip $2))),
  $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12))
endef

define require_head =
$(call require_abs_head,
  $1,
  $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $(strip $2))),
  $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12))
endef

define require_tail =
$(call require_abs_tail,
  $1,
  $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $(strip $2))),
  $3, $4, $5, $6, $7, $8, $9, $(10), $(11), $(12))
endef

require_abs             = $(require_abs_body)
define require_abs_body =
$(call m.in/require, body,
                     $1,
                     $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define require_abs_head =
$(call m.in/require, head,
                     $1,
                     $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define require_abs_tail =
$(call m.in/require, tail,
                     $1,
                     $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

##
# implement_abs()
# Provide an interface/component implementation.
# Arguments:
#   1: component name
#   2: component build directory
implement_abs = $(m.in/implement)
realize_abs   = $(implement_abs)

##
# implement(component, objects[], dependencies[])
#
define implement =
$(call implement_abs, $(m.in/argv/1),
                      $(addprefix $(m.in/cbd), $(m.in/argv/2)),
                      $3)
endef
realize          = $(implement)

##
# link(component, args...?)
# link(         , objects)
# Link against a component's implementation
#
link             = $(link_body)
define link_body =
$(call link_abs_body, $1,
                      $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $2)),
                      $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define link_head =
$(call link_abs_head, $1,
                      $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $2)),
                      $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define link_tail =
$(call link_abs_tail, $1,
                      $(if $(strip $1), $2, $(addprefix $(m.in/cwd), $2)),
                      $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

link_abs             = $(link_abs_body)
define link_abs_body =
$(call m.in/link,body, $1, $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define link_abs_head =
$(call m.in/link,head, $1, $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

define link_abs_tail =
$(call m.in/link,tail, $1, $2, $3, $4, $5, $6, $7, $8, $9, $(10), $(11))
endef

## \}
