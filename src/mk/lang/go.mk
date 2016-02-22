##
# Go language rules and recipes.
#

vpath %.go $(m.in/root)

define m.in/lang/add.go =
$(call link,, $(m.in/argv/2))
endef
