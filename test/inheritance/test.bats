load ../common

function expected() {
  echo "[ test/reflect/transaction ] impl1$
transaction impl1$
   interfaces: $1/c/if1 $1/c/if2 $1/c/if3$
     head: $
     body: $1/c/if1 $1/c/if2 $1/c/if3$
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] dir1/impl1$
transaction dir1/impl1$
   interfaces: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5 $1/dir1/dir3/c3/if1 $1/dir1/dir3/c3/if2 $1/dir1/dir3/c3/if3 $1/dir1/dir3/c3/if4 $1/dir1/dir3/c3/if5 $1/dir1/dir3/c3/if6 $1/dir1/dir3/c3/if7$
     head: $1/c/if1 $1/c/if2 $1/c/if3$
     body: $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5 $1/dir1/dir3/c3/if1 $1/dir1/dir3/c3/if2 $1/dir1/dir3/c3/if3 $1/dir1/dir3/c3/if4 $1/dir1/dir3/c3/if5 $1/dir1/dir3/c3/if6 $1/dir1/dir3/c3/if7$
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] dir1/dir2/impl1$
transaction dir1/dir2/impl1$
   interfaces: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5 $1/dir1/dir3/c3/if1 $1/dir1/dir3/c3/if2 $1/dir1/dir3/c3/if3 $1/dir1/dir3/c3/if4 $1/dir1/dir3/c3/if5 $1/dir1/dir3/c3/if6 $1/dir1/dir3/c3/if7$
     head: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5 $1/dir1/dir3/c3/if1 $1/dir1/dir3/c3/if2 $1/dir1/dir3/c3/if3 $1/dir1/dir3/c3/if4 $1/dir1/dir3/c3/if5 $1/dir1/dir3/c3/if6 $1/dir1/dir3/c3/if7$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] dir1/impl2$
transaction dir1/impl2$
   interfaces: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c2/if1 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5$
     head: $1/c/if1 $1/c/if2 $1/c/if3$
     body: $1/dir1/c2/if1 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5$
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] dir1/dir3/impl1$
transaction dir1/dir3/impl1$
   interfaces: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c2/if1 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5$
     head: $1/c/if1 $1/c/if2 $1/c/if3 $1/dir1/c2/if1 $1/dir1/c1/if1 $1/dir1/c1/if2 $1/dir1/c1/if3 $1/dir1/c1/if4 $1/dir1/c1/if5$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] impl2$
transaction impl2$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $"
}


#
# in-source
#

@test "in-source interface tree" {
  run make -s m.in/term/color=
  output=$(echo "$output" | cat -e)
  make -s distclean
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected .)" ]
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source interface tree" {
  run make -s -f ../Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected ..)" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source interface tree" {
  run make -s -f $BATS_TEST_DIRNAME/Makefile m.in/term/color=
  output=$(echo "$output" | cat -e)
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected $BATS_TEST_DIRNAME)" ]
}
