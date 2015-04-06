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
