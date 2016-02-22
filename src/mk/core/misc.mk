##
# Library of generic functions.
#

##
# m.in/is_abs(path)
# True when `path` is an absolute path, i.e. starts with character `/`,
# false otherwise.
#
m.in/is_abs = $(filter /%,$(m.in/argv/1))

m.in/argv/1  = $(call m.in/argv, $1)
m.in/argv/2  = $(call m.in/argv, $2)
m.in/argv/3  = $(call m.in/argv, $3)
m.in/argv/4  = $(call m.in/argv, $4)
m.in/argv/5  = $(call m.in/argv, $5)
m.in/argv/6  = $(call m.in/argv, $6)
m.in/argv/7  = $(call m.in/argv, $7)
m.in/argv/8  = $(call m.in/argv, $8)
m.in/argv/9  = $(call m.in/argv, $9)
m.in/argv/10 = $(call m.in/argv, $(10))

define m.in/argv =
$(or $(strip $1), $(error missing mandatory argument))
endef

##
# m.in/argc(argv...)
# Count the number of arguments from 0 to 10.
#
# Arguments:
#   argv...
#     List of arguments.
#
# Usage:
# Write simple polymorphic macros according to the number of arguments.
# ```
# foo = $(foo_$(m.in/argc)_)
# foo_1_ = $(info one arg version foo($1))
# foo_1_ = $(info two args version foo($1, $2))
# ```
# Prefer using `m.in/mandatory()` to check your arguments.
#
define m.in/argc =
$(or $(and $(strip $(10)),10),
     $(and $(strip $9),9),
     $(and $(strip $8),8),
     $(and $(strip $7),7),
     $(and $(strip $6),6),
     $(and $(strip $5),5),
     $(and $(strip $4),4),
     $(and $(strip $3),3),
     $(and $(strip $2),2),
     $(and $(strip $1),1),
     0)
endef

##
# m.in/assert(boolean, message)
# Throw an error when `boolean` is false.
# Warning: escape evaluation when the condition depends upon the inner macro.
# define example =
#   foo = ok
#   $$(call m.in/assert, $$(foo), ko)
# endef
# $(eval $(exampe))
# $(foo) -> ok
# vs
# define example =
#   foo = ok
#   $(call m.in/assert, $(foo), ko)
# endef
# $(eval $(exampe)) -> ko
# $(foo)
#
define m.in/assert =
$(if $(strip $1),,$(call m.in/error, $2))
endef

##
# m.in/error(message)
# Print `message` and throw an error.
#
define m.in/error =
$(error $(m.in/term/tag/error) $(strip $1))
endef

##
# m.in/error(message)
# Print a warning `message`.
#
define m.in/warning =
$(warning $1)
endef

##
# Stack data structure.
# \{
#

##
# m.in/stack(stack)
#
m.in/stack = $(m.in/stacks/$(m.in/argv/1))

##
# m.in/stack/push(stack, element)
#
define m.in/stack/push =
m.in/stacks/$(m.in/argv/1) := $(m.in/argv/2) $(call m.in/stack,$(m.in/argv/1))
endef
$(eval $(call m.in/debug/trace/3, m.in/stack/push))

##
# m.in/stack/peek(stack)
#
define m.in/stack/peek =
$(strip
  $(firstword $(call m.in/stack,$(m.in/argv/1)))
)
endef

##
# m.in/stack/pop(stack)
#
define m.in/stack/pop =
m.in/stacks/$(m.in/argv/1) := $(wordlist 2, $(words $(call m.in/stack,$(m.in/argv/1))), $(call m.in/stack,$(m.in/argv/1)))
endef
$(eval $(call m.in/debug/trace/3, m.in/stack/pop))

##
# m.in/stack/at(stack, index)
#
define m.in/stack/at =
$(strip
  $(wordlist $(m.in/argv/2), $(m.in/argv/2), $(call m.in/stack,$(m.in/argv/1)))
)
endef

## \}

m.in/list/variable    = $(call m.in/list/variable_$(m.in/argc)_,$1,$2)
m.in/list/variable_1_ = m.in/lists/$(m.in/argv/1)
define m.in/list/variable_2_ =
$(call m.in/list/variable, $(m.in/argv/1)/$(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/3, m.in/list/variable))

##
# m.in/list(list, type?)
#
m.in/list    = $(strip $(call m.in/list_$(m.in/argc)_,$1,$2))
m.in/list_1_ = $($(call m.in/list/variable, $(m.in/argv/1)))
m.in/list_2_ = $($(call m.in/list/variable, $(m.in/argv/1), $(m.in/argv/2)))
$(eval $(call m.in/debug/trace/3, m.in/list))

##
# m.in/list/value(list, type?)
#
m.in/list/value    = $(call m.in/list/value_$(m.in/argc)_,$1,$2)
m.in/list/value_1_ = $(value $(call m.in/list/variable, $(m.in/argv/1)))
m.in/list/value_2_ = $(value $(call m.in/list/variable, $(m.in/argv/1), $(m.in/argv/2)))
$(eval $(call m.in/debug/trace/3, m.in/list))

##
# m.in/list/add(list, elements[], type?)
# Push back the element to the list: `list::element` if the element
# is not empty.
#
# Arguments:
#  list
#  element
#    Non-null element.
#
define m.in/list/add    =
$(call m.in/list/add_$(m.in/argc)_,$1,$2,$3)
endef
$(eval $(call m.in/debug/trace/3, m.in/list/add))
define m.in/list/add_2_ =
$(call m.in/list/variable, $(m.in/argv/1)) += $(m.in/argv/2)
endef
define m.in/list/add_3_ =
$(call m.in/list/add, $(m.in/argv/1), $(m.in/argv/2))
$(call m.in/list/add, $(m.in/argv/1)/$(m.in/argv/3), $(m.in/argv/2))
endef

##
# m.in/list/flush(list)
#
# Arguments:
#  list
#
define m.in/list/flush =
$(foreach var, $(filter $(call m.in/list/variable, $(m.in/argv/1))%, $(.VARIABLES)),
  undefine $(var))
endef
$(eval $(call m.in/debug/trace/3, m.in/list/flush))

##
# m.in/expand(string, args...)
# Expand a string.
#
define m.in/expand =
$(eval define m.in/expand/result_ =
$1
endef)\
$(call m.in/expand/result_,$(strip $2),$(strip $3),$(strip $4),$(strip $5),$(strip $6),$(strip $7),$(strip $8),$(strip $9),$(strip $(10)),$(strip $(11)))
endef
$(eval $(call m.in/debug/trace/3, m.in/expand))

##
# m.in/is_subdir(base, path)
# Determine whether `path` is a subdirectory of `base`.
#
# Return:
# True when `path` is a subdirectory of `base`.
#
# Implementation:
# True (non-empty string) when the absolute path of `path` is prefixed by
# the absolute path of `base`.
#
define m.in/is_subdir =
$(strip
	$(and $(filter $(abspath $(m.in/argv/1))%, $(abspath $(m.in/argv/2))), t)
)
endef
$(eval $(call m.in/debug/trace/3, m.in/is_subdir))

##
# m.in/proxy(command, recipe)
# Proxy a recipe through a proxy command.
# This macro is a no-op when `command` is empty.
# Warning, this recipe changes the overall recipe execution method of make,
# but shouldn't introduce errors. Cf. implementation details.
#
# Arguments:
#   command
#     proxy command reading commands from stdin
#   recipe
#     recipe variable name
#
# Implementation:
# The difficulty is that a recipe may be multi-line and that by default,
# newlines are processed by make since it runs one shell per line. The
# `\` does not help since we don't know the content of the recipe, so
# there is no (simple) way to add `;\` at the end of line.
# So the idea was to use a multi-line command, correctly receiving its
# newlines to send it to stdin using the here-document redirection.
# Here-doc redirection cannot be written in one line, newlines are
# required.
# The only solution found was to use the `.ONESHELL:` directive.
#
# This directive enables recipe execution in one shell instead of one
# shell per line of recipe. The effect is global and cannot be local
# to a single rule and recipe. When it appears anywhere in the
# Makefile then **all** recipe lines **for each** target will be
# provided to a single invocation of the shell `$(SHELL)`.
#
# The Pros:
#   - Multi-line recipes are possible and newlines are processed by the shell.
#     This makes possible the use of here-doc redirection which cannot be
#     written in one line and need newlines to be correct. Cf. `m.in/proxy()`.
#   - One shell process per recipe instead of one shell process per line of
#     recipe.
#
# The Cons:
#   - The shell must handle intermediate errors.
#   - Make prints one command at a time, which is every lines of the recipe
#     with `.ONESHELL` enabled. If the proxy command does not echo the commands
#     it executes, linking error messages to their command can be more
#     difficult.
#
# Shell flags are set to keep the default make behaviour of exiting on
# error (i.e., `-e`).
#
define m.in/proxy/recipe =
# implicit forwarding to m.in/proxy_ when proxy command set
# submacro needed to avoid problem with newlines with `$(if)`.
$(if $(strip $1),$(m.in/proxy/recipe_))
endef
define m.in/proxy/recipe_ =
.ONESHELL:
.SHELLFLAGS = -ec
$(call m.in/debug/info, proxy $(m.in/argv/2) through $(firstword $(m.in/argv/1)))
define $(m.in/argv/2) =
$1 <<EOF
$(value $(m.in/argv/2))
EOF
endef
endef

##
# m.in/proxy/target(command, target-prefix?)
# Create a new target which proxies make calls to a command throught its
# command line.
# The new target uses pattern matching (`%`) prefixed by `proxy-` by default
# or argument `target-prefix` if provided.
# This macro is a no-op when `command` is empty.
#
# Arguments:
#   command
#     proxy command reading commands from its last.
#   target-prefix?
#     prefix of the target pattern.
#
# Example:
# Proxy any make target through docker:
# ```
# $(eval $(call m.in/proxy, docker run my-image, docker\:))
# ```
# This results in the target `docker:%` and matches targets like `make docker:all`
# resulting in `docker run my-imake make all`.
#
# Usage:
# This is an explicit way of proxying, while `m.in/proxy/recipe()` tries
# to make it transparent and more selective at the recipe level.
# In this case, you manually trigger the proxy.
#
# Implementation:
# Use a single-line recipe to avoid `.ONESHELL:` as much as possible (but reading
# from stdin instead of the command line would be a better/cleaner interface).
# Use the built-in variable $(MAKE) to keep make flags.
#
define m.in/proxy/target =
$(if $(strip $1),$(m.in/proxy/target_))
endef
define m.in/proxy/target_ =
$(or $(strip $2),proxy-)%:
	@echo "$$(call m.in/term/vfx/target, $$@)"
	$(m.in/argv/1) $$(MAKE) $$*
endef
