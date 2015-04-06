# component parameters
$(eval $(call provide, printer, include $$1/include))
$(eval $(call implement, printer, $$1/libprinter.a))

# start a new transaction to create `printer`'s implementation
$(eval $(call make,library,$(FORMAT)/libprinter.a))

$(eval $(call include,$(FORMAT)))
