##
# Transaction management.
#
# Transactions are an automatic way of managing target prerequisities.
# Each target has its transaction where each prerequisite is stored.
# It allows the distinction between dependencies and prerequisities:
# officially, a rule only states its prerequisities which is insufficient
# to be able to express pure dependencies.
# The commonly used workaround is to use a variable to store the target's
# objects and use the built-in prerequisities' list for the target's
# dependencies - the variable is thus directly used in the recipe to
# retrieve the object list (instead of $^ which would contain everything).
#
# Example:
#   How do you exhaustively define a program's dependency ?
#
#     myprogram: obj1.o obj2.o linker.lds
#     ^^^^^^^^^  ^^^^^^^^^^^^^ ^^^^^^^^^^
#      target        prereq    dependency
#
#   The problem here is we cannot use the built-in functionality to specify
#   both prerequisities and dependencies which results in $^.
#
# Thus, a transaction is a list of a target's prerequisities.
# To allow out-of-order insertions into a transaction, the list is
# into 3 positions: head :: body :: tail. So that objects can be pushed back
# into one of these 3 positions. Depending on the underlying language and
# recipe used, the order may matter or not.
#
# Example:
#   In C language, the linking of objects requires a strict ordering from
#   undefined to defined references (from callers to callees). So system
#   libraries are always in the list's tail and C runtime initialization
#   routines are in the list's head. Theses problems are faced when writting
#   new toolchain's target makers where you may need to append additional
#   objects into current transaction.
#
#     crt0.o main.o libc.a
#     ^^^^^^ ^^^^^^ ^^^^^^
#      head   body   tail
#     ^^^^^^^^^^^^^^^^^^^^
#          transaction
#            ^^^^^^
#         prerequisite
#     ^^^^^^^^^^^^^^^^^^^^
#         dependencies
#
#  The rule will now look like:
#    myprogram: crt0.o main.o libc.a linker.lds
#        ld -T linker.lds -o myprogram crt0.o main.o libc.a
#
# \{
#

##
# m.in/transaction/create(file)
# Create a new transaction and set it as the current one.
#
# Arguments
#  file
#    Transaction identifier.
#
define m.in/transaction/create =
$(if $(filter $(dir $(m.in/transaction/current)), $(dir $(m.in/argv/1))),
  $(eval $(call m.in/transactions/pop)))
$(if $(m.in/transaction/current),
  $(call m.in/transaction/inherit, $(m.in/argv/1),
                                   $(m.in/transaction/current)))
$(call m.in/transactions/push, $(m.in/argv/1))
m.in/transaction/$(m.in/argv/1) := t
$(call m.in/transaction/flush, $(m.in/argv/1))
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/create))

m.in/transaction/current = $(m.in/transactions/peek)

##
# m.in/transaction/is_created(transaction)
# True when the transaction is created.
#
m.in/transaction/is_created = $(m.in/transaction/$(m.in/argv/1))
$(eval $(call m.in/debug/trace/2, m.in/transaction/is_created))

##
# m.in/transaction/add(transaction, position, objects[], type?)
# Push back the object into the transaction's tail.
# `transaction | tail` becomes `transaction | tail object`.
#
# Arguments:
#  object
#    Object to add in the transaction's tail.
#
define m.in/transaction/add =
$(call m.in/list/add, m.in/transaction/$(m.in/argv/1)/$(m.in/argv/2),
                      $(m.in/argv/3),
                      $4)
endef
$(eval $(call m.in/debug/trace/3, m.in/transaction/add))

##
# m.in/transaction/get(transaction, position?, type?)
#
# Arguments:
#  object
#    Object to add in the transaction's tail.
#
define m.in/transaction/get =
$(strip
   $(if $(strip $2),
    $(call m.in/list, m.in/transaction/$(m.in/argv/1)/$(m.in/argv/2), $3),
    $(call m.in/list, m.in/transaction/$(m.in/argv/1)/head, $3)
    $(call m.in/list, m.in/transaction/$(m.in/argv/1)/body, $3)
    $(call m.in/list, m.in/transaction/$(m.in/argv/1)/tail, $3))
)
endef

##
# m.in/transaction/value(transaction, type)
#
# Arguments:
#
define m.in/transaction/value =
$(strip
    $(value $(call m.in/list/variable, m.in/transaction/$(m.in/argv/1)/head,
                                       $(m.in/argv/2)))
    $(value $(call m.in/list/variable, m.in/transaction/$(m.in/argv/1)/body,
                                       $(m.in/argv/2)))
    $(value $(call m.in/list/variable, m.in/transaction/$(m.in/argv/1)/tail,
                                       $(m.in/argv/2)))
)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/value))

##
# m.in/transaction/flush(transaction)
#
# Arguments:
#
define m.in/transaction/flush =
$(call m.in/list/flush, m.in/transaction/$(m.in/argv/1)/head)
$(call m.in/list/flush, m.in/transaction/$(m.in/argv/1)/body)
$(call m.in/list/flush, m.in/transaction/$(m.in/argv/1)/tail)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/flush))

##
# m.in/transaction/interfaces/add(transaction, position, interfaces[])
#
define m.in/transaction/interfaces/add =
$(call m.in/transaction/add, $(m.in/argv/1),
                             $(m.in/argv/2),
                             $(m.in/argv/3),
                             interfaces)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/interfaces/add))

##
# m.in/transaction/interfaces(transaction, position?)
#
define m.in/transaction/interfaces =
$(strip
  $(call m.in/transaction/interfaces_$(m.in/argc)_,$1,$2)
)
endef
define m.in/transaction/interfaces_1_ =
$(call m.in/transaction/get, $(m.in/argv/1), , interfaces)
endef
define m.in/transaction/interfaces_2_ =
$(call m.in/transaction/get, $(m.in/argv/1), $(m.in/argv/2), interfaces)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/interfaces))

##
# m.in/transaction/implementations/add(transaction, position, implementations[])
#
define m.in/transaction/implementations/add =
$(call m.in/transaction/add, $(m.in/argv/1),
                             $(m.in/argv/2),
                             $(m.in/argv/3),
                             implementations)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/implementations/add))

##
# m.in/transaction/implementations(transaction, position?)
#
define m.in/transaction/implementations =
$(strip
  $(call m.in/transaction/implementations_$(m.in/argc)_,$1,$2)
)
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/implementations))

define m.in/transaction/implementations_1_ =
$(call m.in/transaction/get, $(m.in/argv/1), , implementations)
endef
define m.in/transaction/implementations_2_ =
$(call m.in/transaction/get, $(m.in/argv/1), $(m.in/argv/2), implementations)
endef

##
# m.in/transaction/inherit(transaction, from)
# Inherit from transaction.
#
define m.in/transaction/inherit =
$(if $(filter $(m.in/argv/1), $(m.in/argv/2)),,
  $(call m.in/transaction/interfaces/add,
    $(m.in/argv/1),
    head,
    $$(call m.in/transaction/interfaces, $(m.in/argv/2))))
endef
$(eval $(call m.in/debug/trace/2, m.in/transaction/inherit))

m.in/transactions/stack = $(call m.in/stack, m.in/transactions/stack)
m.in/transactions/push  = $(call m.in/stack/push, m.in/transactions/stack, $(m.in/argv/1))
m.in/transactions/pop   = $(call m.in/stack/pop, m.in/transactions/stack)
m.in/transactions/peek  = $(call m.in/stack/peek, m.in/transactions/stack)
define m.in/transactions/save =
$(if $(m.in/transaction/current),
  $(eval $(call m.in/transactions/push, $(m.in/transaction/current))))
endef
define m.in/transactions/restore =
$(call m.in/transactions/pop)
endef
$(eval $(call m.in/debug/trace/2, m.in/transactions/push     \
                                  m.in/transactions/pop))

m.in/transaction = $(error nononono)

## \}
