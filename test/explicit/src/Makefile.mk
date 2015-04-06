$(eval $(call prerequisites,main.o))

# introduction of a build parameter
$(eval $(call include,printer/$(FORMAT)))

# make sure the order does not matter
# require printer's interface to the subtree
$(eval $(call require,,printer/include))
