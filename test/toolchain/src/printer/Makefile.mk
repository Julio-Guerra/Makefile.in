# define component `printer` whose public interface is `include` and
# implementation is `libprinter.a`
$(eval $(call provide,printer,include))
$(eval $(call implement,printer,libprinter.a))

# start a new transaction to create `printer`'s implementation
$(eval $(call make,library,libprinter.a))
$(eval $(call include,$(FORMAT)))

# require our own public interface to implement it
# the order does not matter
$(eval $(call require,printer))
