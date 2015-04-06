load ../common

#
# in-source
#

function expected() {
  prefix=${2-.}
  echo "[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/if/static $prefix/if/generated$
     head: $
     body: $1/if/static $prefix/if/generated$
     tail: $
   implementations: $prefix/lib/libgenerated.a $1/lib/libstatic.a$
     head: $
     body: $prefix/lib/libgenerated.a $1/lib/libstatic.a$
     tail: $"
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build overriding component prefix" {
  tmp=$(test_tmpdir)
  mkdir -p $tmp/lib
  touch "$tmp/lib/libgenerated.a"
  echo "\$(eval \$(call m.in/component/prefix/set, test, $tmp/))" > test.mk

  run make -s -f ../Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected .. $tmp)" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source build overriding component prefix" {
  tmp=$(test_tmpdir)
  mkdir -p $tmp/lib
  touch "$tmp/lib/libgenerated.a"
  echo "\$(eval \$(call m.in/component/prefix/set, test, $tmp/))" > test.mk

  run make -s -f $BATS_TEST_DIRNAME/Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  [ $status -eq 0 ]
  [ "$output" = "$(expected $BATS_TEST_DIRNAME $tmp)" ]
}

@test "in-source build" {
  run make -s m.in/term/color=
  make -s m.in/term/color= distclean
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected .)" ]
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build" {
  mkdir lib
  touch lib/libgenerated.a

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
  mkdir lib
  touch lib/libgenerated.a

  run make -s -f $BATS_TEST_DIRNAME/Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  [ $status -eq 0 ]
  [ "$output" = "$(expected $BATS_TEST_DIRNAME)" ]
}
