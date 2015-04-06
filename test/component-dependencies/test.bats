load ../common

#
# in-source
#

function expected() {
  echo "[ test/*/archive ] lib/libgenerated.a$
transaction lib/libgenerated.a$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/*/archive ] lib/dep1/libgenerated.a$
transaction lib/dep1/libgenerated.a$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/*/archive ] lib/dep3/libgenerated.a$
transaction lib/dep3/libgenerated.a$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/if/static ./if/generated $1/dep2/if/static ./dep2/if/generated $1/dep4/if/static ./dep4/if/generated $1/dep5/if/static ./dep5/if/generated$
     head: $
     body: $1/if/static ./if/generated $1/dep2/if/static ./dep2/if/generated $1/dep4/if/static ./dep4/if/generated $1/dep5/if/static ./dep5/if/generated$
     tail: $
   implementations: ./lib/libgenerated.a $1/lib/libstatic.a ./lib/dep1/libgenerated.a $1/lib/dep1/libstatic.a ./lib/dep3/libgenerated.a $1/lib/dep3/libstatic.a$
     head: $
     body: ./lib/libgenerated.a $1/lib/libstatic.a ./lib/dep1/libgenerated.a $1/lib/dep1/libstatic.a ./lib/dep3/libgenerated.a $1/lib/dep3/libstatic.a$
     tail: $"
}

function expected2() {
  echo "[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/if/static $2/if/generated $1/dep2/if/static $2/dep2/if/generated $1/dep4/if/static $2/dep4/if/generated $1/dep5/if/static $2/dep5/if/generated$
     head: $
     body: $1/if/static $2/if/generated $1/dep2/if/static $2/dep2/if/generated $1/dep4/if/static $2/dep4/if/generated $1/dep5/if/static $2/dep5/if/generated$
     tail: $
   implementations: $2/lib/libgenerated.a $1/lib/libstatic.a $2/lib/dep1/libgenerated.a $1/lib/dep1/libstatic.a $2/lib/dep3/libgenerated.a $1/lib/dep3/libstatic.a$
     head: $
     body: $2/lib/libgenerated.a $1/lib/libstatic.a $2/lib/dep1/libgenerated.a $1/lib/dep1/libstatic.a $2/lib/dep3/libgenerated.a $1/lib/dep3/libstatic.a$
     tail: $"
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build overriding component prefix" {
  tmp=$(test_tmpdir)
  touch test.mk
  for c in dep1 dep2 dep3 dep4 dep5; do
    mkdir -p $tmp/lib/$c
    touch $tmp/lib/$c/libgenerated.a
    echo "\$(eval \$(call m.in/component/prefix/set, $c, $tmp/))" >> test.mk
  done
  touch $tmp/lib/libgenerated.a
  echo "\$(eval \$(call m.in/component/prefix/set, test, $tmp/))" >> test.mk

  run make -s -f ../Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected2 .. $tmp)" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source build overriding component prefix" {
  tmp=$(test_tmpdir)
  touch test.mk
  for c in dep1 dep2 dep3 dep4 dep5; do
    mkdir -p $tmp/lib/$c
    touch $tmp/lib/$c/libgenerated.a
    echo "\$(eval \$(call m.in/component/prefix/set, $c, $tmp/))" >> test.mk
  done
  touch $tmp/lib/libgenerated.a
  echo "\$(eval \$(call m.in/component/prefix/set, test, $tmp/))" >> test.mk

  run make -s -f $BATS_TEST_DIRNAME/Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected2 $BATS_TEST_DIRNAME $tmp)" ]
}

@test "in-source build" {
  run make -s m.in/term/color=
  make -s m.in/term/color= distclean
  find . -name libgenerated.a -delete
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected .)" ]
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build" {
  run make -s -f ../Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected ..)" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source build" {
  run make -s -f $BATS_TEST_DIRNAME/Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  [ $status -eq 0 ]
  [ "$output" = "$(expected $BATS_TEST_DIRNAME)" ]
}
