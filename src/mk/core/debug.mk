##
# Library of debugging functions.
#

ifdef m.in/debug

##
# Ordered list of levels
# Trace when position(selected) >= position(level)
# Usage:
# m.in/debug/trace/level := mylevel $(m.in/debug/trace/level)
#
m.in/debug/trace/levels := 1 2 3

$(foreach l, $(m.in/debug/trace/levels),                                  \
  $(eval m.in/debug/trace/$l = m.in/debug/trace/list/$l += $$(strip $$1)))

##
# Trace a level
#
define m.in/debug/trace/level =
$(foreach f, $(m.in/debug/trace/list/$(m.in/argv/1)), \
  $(call m.in/debug/trace, $f))
endef

##
# m.in/debug/trace(macro)
# Tracing won't work with implicit forwarding, since it is like inlining,
# the resulting trace will show the caller intead of the callee.
#
define m.in/debug/trace =
$(call m.in/debug/info, tracing $(m.in/argv/1))
define $(m.in/argv/1) =
$$(m.in/debug/trace/in)$(value $(m.in/argv/1))$$(m.in/debug/trace/out)
endef
endef

define m.in/debug/trace/in =
$(strip
  $(m.in/debug/trace/echo)
  $(eval $(m.in/debug/info/inctab))
)
endef

define m.in/debug/trace/out =
$(strip
  $(eval $(m.in/debug/info/dectab))
)
endef

define m.in/debug/trace/echo =
$(m.in/debug/trace/echo_$(m.in/argc)_)
endef

define m.in/debug/trace/echo/ftrace =
$(call m.in/debug/info, $(call m.in/term/vfx/function, $(m.in/argv/1), $(m.in/argv/2)))
endef

define m.in/debug/trace/echo/vtrace =
$(call m.in/debug/info, $(call m.in/term/vfx/variable, $(m.in/argv/1)))
endef

m.in/debug/trace/echo_0_  = $(if $0,$(call m.in/debug/trace/echo/vtrace, $0))
m.in/debug/trace/echo_1_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1)))
m.in/debug/trace/echo_2_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1), \
                                                      $(m.in/argv/2)))
m.in/debug/trace/echo_3_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1), \
                                                      $(m.in/argv/2), \
                                                      $(m.in/argv/3)))
m.in/debug/trace/echo_4_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                      $(m.in/argv/2),	\
                                                      $(m.in/argv/3),	\
                                                     $(m.in/argv/4)))
m.in/debug/trace/echo_5_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5)))
m.in/debug/trace/echo_6_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5),	\
                                                     $(m.in/argv/6)))
m.in/debug/trace/echo_7_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5),	\
                                                     $(m.in/argv/6),	\
                                                     $(m.in/argv/7)))
m.in/debug/trace/echo_8_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5),	\
                                                     $(m.in/argv/6),	\
                                                     $(m.in/argv/7),	\
                                                     $(m.in/argv/8)))
m.in/debug/trace/echo_9_  = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5),	\
                                                     $(m.in/argv/6),	\
                                                     $(m.in/argv/7),	\
                                                     $(m.in/argv/8),	\
                                                     $(m.in/argv/9)))
m.in/debug/trace/echo_10_ = $(call m.in/debug/trace/echo/ftrace, $0, ($(m.in/argv/1),	\
                                                     $(m.in/argv/2),	\
                                                     $(m.in/argv/3),	\
                                                     $(m.in/argv/4),	\
                                                     $(m.in/argv/5),	\
                                                     $(m.in/argv/6),	\
                                                     $(m.in/argv/7),	\
                                                     $(m.in/argv/8),	\
                                                     $(m.in/argv/9),  \
                                                     $(m.in/argv/10)))

define m.in/debug/trace/install =
$(foreach l, $(m.in/debug/trace/levels),             \
  $(eval str += $$(call m.in/debug/trace/level, $l))
  $(and $(filter $(m.in/debug), $l), $(str)))
endef

##
# m.in/debug/info(message)
# Debug information printer.
#
define m.in/debug/info =
$(strip
  $(eval m.in/debug/info/n := $(shell echo $$(($(m.in/debug/info/n) + 1))))
  $(info $(call m.in/term/vfx/discreet, debug:$(m.in/debug/info/n))$(m.in/debug/info/tabs)$1)
)
endef

m.in/debug/info/tab := 0
define m.in/debug/info/tabs =
$(shell for s in $$(seq $(m.in/debug/info/tab)); do echo -n '  '; done)
endef

define m.in/debug/info/inctab =
$(eval m.in/debug/info/tab := $(shell echo $$(($(m.in/debug/info/tab) + 1))))
endef

define m.in/debug/info/dectab =
$(eval m.in/debug/info/tab := $(shell echo $$(($(m.in/debug/info/tab) - 1))))
endef

endif
