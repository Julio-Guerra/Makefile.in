##
# Component Management
#

##
# Member name getter.
#
m.in/component/member = m.in/component/$(m.in/argv/1)/$(m.in/argv/2)

##
# m.in/component/add(component, member, value)
# Add objects generated or not to the list `member`.
#
define m.in/component/add =
$(call m.in/list/add, $(call m.in/component/member, $(m.in/argv/1), $(m.in/argv/2)),
                      $(m.in/argv/3))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/add))
##
# m.in/component/set(component, member, value)
#
define m.in/component/set =
$(call m.in/list/flush, $(call m.in/component/member, $(m.in/argv/1),
                                                      $(m.in/argv/2)))
$(call m.in/list/add, $(call m.in/component/member, $(m.in/argv/1),
                                                    $(m.in/argv/2)),
                      $(m.in/argv/3))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/set))

##
# m.in/component/get(component, member)
#
define m.in/component/get =
$(strip
  $(if $(call m.in/component/is_defined, $(m.in/argv/1), $(m.in/argv/2)),,
    $(eval $(m.in/component/fetch)))
  $(or $(call m.in/list/value, $(call m.in/component/member, $(m.in/argv/1),
                                                             $(m.in/argv/2))),
    $(call m.in/error, component `$(m.in/argv/1)` does not provide any $(m.in/argv/2)))
)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/get))

##
# m.in/component/is_defined(component, member)
# Return true (i.e. non-empty string) if the component is defined.
#
# Arguments:
#  component
#    Component's name.
#
define m.in/component/is_defined =
$(and $(call m.in/component/value, $(m.in/argv/1), $(m.in/argv/2)), t)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/is_defined))

define m.in/component/value =
$(call m.in/list/value, $(call m.in/component/member, $(m.in/argv/1),
                                                      $(m.in/argv/2)))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/value))

define m.in/component/build =
$(strip
  $(or
    $(if $(call m.in/component/is_defined, $(m.in/argv/1), prefix),
      $(call m.in/component/get, $(m.in/argv/1), prefix)),
    $(call m.in/component/get, $(m.in/argv/1), build))
)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/build))

define m.in/component/build/set =
$(call m.in/component/set, $(m.in/argv/1), build, $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/build/set))

define m.in/component/prefix/set =
$(call m.in/component/set, $(m.in/argv/1), prefix, $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/prefix/set))

##
# m.in/component/prefix(component, paths[])
# Prefix a path according to the component settings. If the path is relative to
# current build directory, then it is variable and depends on the prefix
# `m.in/component/build` while other paths are considered fully fixed.
#
define m.in/component/prefix =
$(strip
  $(foreach p, $(m.in/argv/2),
    $(patsubst ./$(m.in/cbd)%,
      $$(call m.in/component/build, $(m.in/argv/1))$(m.in/cbd)%,
      $(or $(filter /%, $p),
           $(filter ./%, $p),
           $(filter ../%, $p),
           $(addprefix ./, $p)))
  )
)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/prefix))

define m.in/component/implementations/add =
$(call m.in/component/add, $(m.in/argv/1), implementations, $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/implementations/add))

define m.in/component/interfaces/add =
$(call m.in/component/add,$(m.in/argv/1),interfaces,$(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/interfaces/add))

define m.in/component/implementations/dependencies/add =
$(call m.in/component/add, $(m.in/argv/1),
                           implementations/dependencies,
                           $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/implementations/dependencies/add))

define m.in/component/interfaces/dependencies/add =
$(call m.in/component/add, $(m.in/argv/1),
                           interfaces/dependencies,
                           $(m.in/argv/2))
endef
$(eval $(call m.in/debug/trace/2, m.in/component/interfaces/dependencies/add))

define m.in/component/implementations =
$(call m.in/component/get, $(m.in/argv/1), implementations)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/implementations))

define m.in/component/implementations/dependencies =
$(strip
  $(call m.in/component/get, $(m.in/argv/1), implementations/dependencies)
)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/implementations/dependencies))

define m.in/component/implementations/dependencies/value =
$(call m.in/component/value, $(m.in/argv/1), implementations/dependencies)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/implementations/dependencies))

define m.in/component/interfaces/dependencies/value =
$(call m.in/component/value, $(m.in/argv/1), interfaces/dependencies)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/interfaces/dependencies))

define m.in/component/interfaces/dependencies =
$(strip
  $(call m.in/component/get, $(m.in/argv/1), interfaces/dependencies)
)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/interfaces/dependencies))

define m.in/component/interfaces =
$(call m.in/component/get, $(m.in/argv/1), interfaces)
endef
$(eval $(call m.in/debug/trace/2, m.in/component/interfaces))

define m.in/component/fetch =
$(eval
  $(call m.in/debug/info,fetching component `$(m.in/argv/1)`)
  $(eval m.in/component/$(m.in/argv/1)/prefix := $(m.in/toolchain/fetch))
  $(if $(m.in/component/$(m.in/argv/1)/prefix),
    $(call include_abs,$(m.in/component/$(m.in/argv/1)/prefix)/,Library.in),
    $(eval $(call m.in/error,failed fetching interface of component `$(m.in/argv/1)`))))
endef

define m.in/component/if/fetch =
$(eval
  $(call m.in/debug/info,fetching implementation of component `$1`)
  $(eval m.in/component/$1/build := $(m.in/toolchain/fetch/impl))
  $(if $(m.in/component/$1/build),
    $(call include_abs,$(m.in/component/$1/prefix)/,Library.in),
    $(eval $(call m.in/error,failed fetching component `$1`))))
endef

## \}
