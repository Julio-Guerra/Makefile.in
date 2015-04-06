# add `main.c` to current transaction with a custom toolchain-specific
# (here gnu) option
$(eval $(call add,main.c,-Werror))

# introduction of a build parameter
$(eval $(call include,printer/$(FORMAT)))

# make sure the order does not matter
$(eval $(call require,,printer/include))
