$(eval $(call prerequisites,main.o))

# introduction of a build parameter
$(eval $(call include,printer/$(FORMAT)))

# make sure the order does not matter
$(eval $(call require,,printer/include))
