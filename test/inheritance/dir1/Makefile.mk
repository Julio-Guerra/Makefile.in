# inner transaction: inherit from parent (t1).
$(eval $(call make, transaction, impl1))

$(eval $(call provide, c1, c1/if1 c1/if2))
$(eval $(call provide_abs, c1, $(CWD)c1/if3 $(m.in/cwd)c1/if4))
$(eval $(call provide, c1, c1/if5))

# sub-transactions will inherit from this but not parents
$(eval $(call require, c1))

# c5 interfaces provided in dir3
# might be really weird to do this in real life...
$(eval $(call require, c3))

$(eval $(call include, dir2))

$(eval $(call make, transaction, impl2))

$(eval $(call require, , c2/if1))
$(eval $(call require, c1))

$(eval $(call include, dir3))
