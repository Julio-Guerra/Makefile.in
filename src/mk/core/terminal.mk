##
# Terminal Management.
# Default settings.
# Requires terminfo.
# \{
#

##
# Colorized output.
# Boolean.
#
# Example:
#   ```
#   > make
#   colored output by default
#
#   > make m.in/term/color=
#   uncolored output
#   ```
#
m.in/term/color := $(shell [ $$(tput colors) -ge 8 ] && echo t)

##
# Frequently used tags.
# \{
#
m.in/term/tag/warning = $(call m.in/term/vfx/warn,  !)
m.in/term/tag/error   = $(call m.in/term/vfx/error, !)
m.in/term/tag/info    = $(call m.in/term/vfx/info,  +)
## \}

##
# Visual effect macros.
# Apply visual effects to the argument (aka highlight). Macro names are self-explanatory.
# \{
#

define m.in/term/vfx/tag =
$(m.in/term/color/bold)$(m.in/term/color/icyan)[$(m.in/term/color/reset) \
$(m.in/argv/1) \
$(m.in/term/color/bold)$(m.in/term/color/icyan)]$(m.in/term/color/reset)
endef

define m.in/term/vfx/info =
$(call m.in/term/vfx/tag,$(m.in/term/color/bold)$(m.in/term/color/igreen)$(m.in/argv/1))
endef

define m.in/term/vfx/discreet =
$(call m.in/term/vfx/tag, $(m.in/term/color/white)$(m.in/argv/1))
endef

define m.in/term/vfx/error =
$(call m.in/term/vfx/tag,$(m.in/term/color/bold)$(m.in/term/color/red)$(m.in/argv/1))
endef

define m.in/term/vfx/warn =
$(call m.in/term/vfx/tag,$(m.in/term/color/bold)$(m.in/term/color/iyellow)$(m.in/argv/1))
endef

define m.in/term/vfx/sexy =
$(m.in/term/color/bold)$(m.in/term/color/ipurple)`$(m.in/argv/1)`$(m.in/term/color/reset)
endef

define m.in/term/vfx/prereq =
$(call m.in/term/vfx/tag,$(m.in/term/color/bold)$(m.in/term/color/igreen)$(m.in/argv/1))
endef

define m.in/term/vfx/target =
$(call m.in/term/vfx/tag,$(m.in/term/color/bold)$(m.in/term/color/ipurple)$(m.in/argv/1))
endef

define m.in/term/vfx/function =
$(m.in/term/color/ired)$(m.in/argv/1)$(m.in/term/color/reset)$(m.in/argv/2)
endef

define m.in/term/vfx/variable =
$(m.in/term/color/ired)$(m.in/argv/1)$(m.in/term/color/reset)
endef
## \}

##
# ANSI colors.
# \{
#
m.in/term/color/black   = $(if $(m.in/term/color),$(m.in/term/color/esc/black))
m.in/term/color/red     = $(if $(m.in/term/color),$(m.in/term/color/esc/red))
m.in/term/color/green   = $(if $(m.in/term/color),$(m.in/term/color/esc/green))
m.in/term/color/yellow  = $(if $(m.in/term/color),$(m.in/term/color/esc/yellow))
m.in/term/color/blue    = $(if $(m.in/term/color),$(m.in/term/color/esc/blue))
m.in/term/color/purple  = $(if $(m.in/term/color),$(m.in/term/color/esc/purple))
m.in/term/color/cyan    = $(if $(m.in/term/color),$(m.in/term/color/esc/cyan))
m.in/term/color/white   = $(if $(m.in/term/color),$(m.in/term/color/esc/white))

m.in/term/color/iblack  = $(if $(m.in/term/color),$(m.in/term/color/esc/iblack))
m.in/term/color/ired    = $(if $(m.in/term/color),$(m.in/term/color/esc/ired))
m.in/term/color/igreen  = $(if $(m.in/term/color),$(m.in/term/color/esc/igreen))
m.in/term/color/iyellow = $(if $(m.in/term/color),$(m.in/term/color/esc/iyellow))
m.in/term/color/iblue   = $(if $(m.in/term/color),$(m.in/term/color/esc/iblue))
m.in/term/color/ipurple = $(if $(m.in/term/color),$(m.in/term/color/esc/ipurple))
m.in/term/color/icyan   = $(if $(m.in/term/color),$(m.in/term/color/esc/icyan))
m.in/term/color/iwhite  = $(if $(m.in/term/color),$(m.in/term/color/esc/iwhite))

m.in/term/color/reset   = $(if $(m.in/term/color),$(m.in/term/color/esc/reset))
m.in/term/color/bold    = $(if $(m.in/term/color),$(m.in/term/color/esc/bold))
m.in/term/color/blink    = $(if $(m.in/term/color),$(m.in/term/color/esc/blink))
## \}

##
# Escape sequences
# \{
#
m.in/term/color/esc/black   := $(shell tput setaf 0)
m.in/term/color/esc/red     := $(shell tput setaf 1)
m.in/term/color/esc/green   := $(shell tput setaf 2)
m.in/term/color/esc/yellow  := $(shell tput setaf 3)
m.in/term/color/esc/blue    := $(shell tput setaf 4)
m.in/term/color/esc/purple  := $(shell tput setaf 5)
m.in/term/color/esc/cyan    := $(shell tput setaf 6)
m.in/term/color/esc/white   := $(shell tput setaf 7)

m.in/term/color/esc/iblack  := $(shell tput setaf 8)
m.in/term/color/esc/ired    := $(shell tput setaf 9)
m.in/term/color/esc/igreen  := $(shell tput setaf 10)
m.in/term/color/esc/iyellow := $(shell tput setaf 11)
m.in/term/color/esc/iblue   := $(shell tput setaf 12)
m.in/term/color/esc/ipurple := $(shell tput setaf 13)
m.in/term/color/esc/icyan   := $(shell tput setaf 14)
m.in/term/color/esc/iwhite  := $(shell tput setaf 15)

m.in/term/color/esc/reset   := $(shell tput sgr0)
m.in/term/color/esc/bold    := $(shell tput bold)
m.in/term/color/esc/blink   := $(shell tput blink)
## \}

## \}
