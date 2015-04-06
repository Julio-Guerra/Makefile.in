# following `eval` require the gnu toolchain immediately
include $(m.in/toolchain_prefix)/gnu.mk

$(eval $(call provide_abs,   libc, $(m.in/toolchain/gnu/stdinc)))
$(eval $(call implement_abs, libc,                                        \
                             $(call m.in/toolchain/gnu/locate, libc.a),   \
                             libgcc))

$(eval $(call implement_abs, crtbegin,                                       \
                             $(call m.in/toolchain/gnu/locate, crt1.o)       \
                             $(call m.in/toolchain/gnu/locate, crti.o)       \
                             $(call m.in/toolchain/gnu/locate, crtbeginT.o)))

$(eval $(call implement_abs, libgcc,                                         \
                             $(call m.in/toolchain/gnu/locate, libgcc.a)     \
                             $(call m.in/toolchain/gnu/locate, libgcc_eh.a)))

$(eval $(call implement_abs, crtend,                                         \
                             $(call m.in/toolchain/gnu/locate, libc.a)       \
                             $(call m.in/toolchain/gnu/locate, crtend.o)     \
                             $(call m.in/toolchain/gnu/locate, crtn.o)))

# Definition of `myelf` target type.
# Simply rely on gnu's link recipe has `elf` target type but link against
# compiler's C runtime libraries to avoid users this pain.
define m.in/toolchain/gnu/make_myelf =
$(eval $(call make_explicit,
  $1,
  gnu,
  */link/template,
  $2,
  $$(call m.in/transaction/implementations, $1, head) $3
  $$(call m.in/transaction/implementations, $1, body)
  $$(call m.in/transaction/implementations, $1, tail) $4))
$(call require,   libc)
$(call link_tail, crtend)
$(call link,      libc)
$(call link_head, crtbegin)
endef
