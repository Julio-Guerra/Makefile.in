$(eval $(call m.in/rule,%.a :,,*/archive))
$(eval $(call m.in/rule,%.bin :,,*/binary))
$(eval $(call m.in/rule,%.elf :,,*/link))

define m.in/lang/add.a =
$(call link,,$(m.in/argv/2))
endef

define m.in/lang/add.o =
$(call link,,$(m.in/argv/2))
endef
