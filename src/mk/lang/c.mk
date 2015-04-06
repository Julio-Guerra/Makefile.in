#-
#- C/ASM language rules and recipes.
#-

vpath %.c $(m.in/root)
vpath %.s $(m.in/root)
vpath %.S $(m.in/root)

define m.in/lang/add.c =
$(call prerequisites, $(basename $(m.in/argv/2)).o)
$(call m.in/rule, $(m.in/cbd)$(basename $(m.in/argv/2)).o : $(m.in/cwd)$(m.in/argv/2) $$$$(m.in/global_dependencies), , c/compile,$3,$4,$5,$6,$7,$8,$9)
$(call m.in/include_dynamic_dependency, $(m.in/cbd)$(basename $(m.in/argv/2)).d)
endef

m.in/lang/add.S = $(m.in/lang/add.c)

$(eval $(call m.in/rule, %.d : %.c $$$$(m.in/global_dependencies), , c/dependency))
$(eval $(call m.in/rule, %.o : %.c $$$$(m.in/global_dependencies), , c/compile))
$(eval $(call m.in/rule, %.d : %.S $$$$(m.in/global_dependencies), , c/dependency))
$(eval $(call m.in/rule, %.o : %.S $$$$(m.in/global_dependencies), , c/compile))
$(eval $(call m.in/rule, %.o : %.s $$$$(m.in/global_dependencies), , c/compile))
$(eval $(call m.in/rule, %.i : %.c $$$$(m.in/global_dependencies), , c/preprocess))
