load ../common

function expected0() {
  echo "[ test/c/dependency ] src/main.d$
transaction src/main.d$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/c/dependency ] src/printer/ascii/printer.d$
transaction src/printer/ascii/printer.d$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/c/compile ] src/main.o$
transaction src/main.o$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/c/compile ] src/printer/ascii/printer.o$
transaction src/printer/ascii/printer.o$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] src/printer/ascii/libprinter.a$
transaction src/printer/ascii/libprinter.a$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: src/printer/ascii/printer.o$
     head: $
     body: src/printer/ascii/printer.o$
     tail: $
$
[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $
     body: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     tail: $
   implementations: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     head: $
     body: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     tail: $
$
[ test/*/binary ] hello.bin$
transaction hello.bin$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: hello$
     head: $
     body: hello$
     tail: $"
}

function expected1() {
  echo "[ test/c/dependency ] src/main.d$
transaction src/main.d$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/c/compile ] src/main.o$
transaction src/main.o$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $
     body: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     tail: $
   implementations: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     head: $
     body: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     tail: $
$
[ test/*/binary ] hello.bin$
transaction hello.bin$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: hello$
     head: $
     body: hello$
     tail: $"
}

function expected2() {
  echo "[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $
     body: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     tail: $
   implementations: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     head: $
     body: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     tail: $
$
[ test/*/binary ] hello.bin$
transaction hello.bin$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: hello$
     head: $
     body: hello$
     tail: $"
}

function expected3() {
  echo "[ test/c/dependency ] src/printer/ascii/printer.d$
transaction src/printer/ascii/printer.d$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/c/compile ] src/printer/ascii/printer.o$
transaction src/printer/ascii/printer.o$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: $
     head: $
     body: $
     tail: $
$
[ test/reflect/transaction ] src/printer/ascii/libprinter.a$
transaction src/printer/ascii/libprinter.a$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     body: $
     tail: $
   implementations: src/printer/ascii/printer.o$
     head: $
     body: src/printer/ascii/printer.o$
     tail: $
$
[ test/reflect/transaction ] hello$
transaction hello$
   interfaces: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     head: $
     body: $1/src/printer/include $1/src/printer/ascii/include $1/lib$
     tail: $
   implementations: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     head: $
     body: src/main.o ./src/printer/ascii/libprinter.a $1/lib/libc.a$
     tail: $
$
[ test/*/binary ] hello.bin$
transaction hello.bin$
   interfaces: $
     head: $
     body: $
     tail: $
   implementations: hello$
     head: $
     body: hello$
     tail: $"
}

#
# in-source
#

@test "in-source build" {
  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  run make FORMAT=ascii m.in/term/color=
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Nothing to be done for 'all'" ]]

  touch src/printer/include/print.h

  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected1 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch src/printer/Makefile.mk

  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch src/printer/ascii/libprinter.a

  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch lib/libc.a

  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch lib/libc.h

  run make -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected3 .)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  make FORMAT=ascii m.in/toolchain=gnu distclean
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build" {
  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  run make -f ../Makefile FORMAT=ascii
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Nothing to be done for 'all'" ]]

  touch ../src/printer/include/print.h

  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected1 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch ../src/printer/Makefile.mk

  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch src/printer/ascii/libprinter.a

  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch ../lib/libc.a

  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch ../lib/libc.h

  run make -f ../Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected3 ..)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source build" {
  run make -f $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  run make -f $BATS_TEST_DIRNAME/Makefile FORMAT=ascii m.in/toolchain=test
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Nothing to be done for 'all'" ]]

  touch $BATS_TEST_DIRNAME/src/printer/include/print.h

  run make -f $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected1 $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch $BATS_TEST_DIRNAME/src/printer/Makefile.mk

  run make -f $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected0 $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch src/printer/ascii/libprinter.a

  run make -f $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2 $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch  $BATS_TEST_DIRNAME/lib/libc.a

  run make -f  $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected2  $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]

  touch  $BATS_TEST_DIRNAME/lib/libc.h

  run make -f  $BATS_TEST_DIRNAME/Makefile -s FORMAT=ascii m.in/term/color=
  output=$(echo "$output" | cat -e)
  expected=$(expected3  $BATS_TEST_DIRNAME)
  [ "$status" -eq 0 ]
  echo "$output"
  [ "$output" = "$expected" ]
}
