#
# Introspection/Reflection toolchain for testing puropose.
#

m.in/toolchain/test/mkdir := mkdir -p
SHELL := bash
define m.in/toolchain/test/recipe/reflect/transaction/template =
echo -e                                                             \
 "transaction $(m.in/argv/1)\n"                                     \
 "  interfaces: $(call m.in/transaction/interfaces, $1)\n"          \
 "    head: $(call m.in/transaction/interfaces, $1, head)\n"        \
 "    body: $(call m.in/transaction/interfaces, $1, body)\n"        \
 "    tail: $(call m.in/transaction/interfaces, $1, tail)\n"        \
 "  implementations: $(call m.in/transaction/implementations,$1)\n" \
 "    head: $(call m.in/transaction/implementations, $1, head)\n"   \
 "    body: $(call m.in/transaction/implementations, $1, body)\n"   \
 "    tail: $(call m.in/transaction/implementations, $1, tail)\n"
$(call m.in/mkdir, $(dir $1))
touch $1
endef

define m.in/toolchain/test/recipe/reflect/transaction =
$(call m.in/toolchain/test/recipe/reflect/transaction/template, $@)
endef

define m.in/toolchain/test/recipe/c/dependency =
echo -e                                                                       \
 "transaction $@\n"                                                           \
 "  interfaces: $(call m.in/transaction/interfaces, $(@:%.d=%.o))\n"          \
 "    head: $(call m.in/transaction/interfaces, $(@:%.d=%.o), head)\n"        \
 "    body: $(call m.in/transaction/interfaces, $(@:%.d=%.o), body)\n"        \
 "    tail: $(call m.in/transaction/interfaces, $(@:%.d=%.o), tail)\n"        \
 "  implementations: $(call m.in/transaction/implementations, $(@:%.d=%.o))\n"\
 "    head: $(call m.in/transaction/implementations, $(@:%.d=%.o), head)\n"   \
 "    body: $(call m.in/transaction/implementations, $(@:%.d=%.o), body)\n"   \
 "    tail: $(call m.in/transaction/implementations, $(@:%.d=%.o), tail)\n"
$(m.in/toolchain/gnu/recipe/c/dependency)
endef

define m.in/toolchain/test/recipe/c/compile =
$(call m.in/toolchain/test/recipe/reflect/transaction/template, $@)
endef

define m.in/toolchain/test/recipe/*/binary =
$(m.in/toolchain/test/recipe/reflect/transaction)
endef

define m.in/toolchain/test/recipe/*/archive =
$(m.in/toolchain/test/recipe/reflect/transaction)
endef

m.in/toolchain/test/recipe/*/clean = $(m.in/toolchain/gnu/recipe/*/clean)
m.in/toolchain/test/recipe/*/distclean = $(m.in/toolchain/gnu/recipe/*/distclean)

define m.in/toolchain/test/make_transaction =
$(call make_explicit, $(m.in/argv/1), test, reflect/transaction)
$(call dependencies_abs, $$$$(m.in/global_dependencies))
endef

m.in/toolchain/test/make_elf     = $(m.in/toolchain/test/make_transaction)
m.in/toolchain/test/make_library = $(m.in/toolchain/test/make_transaction)
m.in/toolchain/test/make_binary  = $(m.in/toolchain/test/make_transaction)
