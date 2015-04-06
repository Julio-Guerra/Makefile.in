m.in/toolchain/web/browserify := browserify

define m.in/toolchain/web/recipe/js/browserify =
$(m.in/toolchain/web/browserify) $< -o $@ $1
endef

define m.in/toolchain/web/recipe/*/copy =
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(m.in/toolchain/gnu/cp) $1 $< $@
endef

define m.in/toolchain/web/make_browserify =
$(call make_explicit,$1,web,js/browserify,$2)
endef

define m.in/toolchain/web/make_copy =
$(call make_explicit,$1,web,*/copy,$2)
endef
