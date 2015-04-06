load ../common

#
# in-source
#

@test "is_subdir macro" {
  tmp=$(test_tmpfile .mk)
  echo '$(info outside: $(call m.in/is_root_subdir,$(CWD)))' > $tmp

  run make OUTSIDE_FILE=$tmp -s
  echo "$output"

  [ $status -eq 0 ]

  expected="root: t
src: t
outside: "
  [ "$output" = "$expected" ]
}

@test "mkdir outside of project's root" {
  run make -s mkdir-ko
  [ $status -ne 0 ]
}

@test "mkdir inside of project's root" {
  make -s mkdir-ok
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source is_subdir macro" {
  tmp=$(test_tmpfile .mk)
  echo '$(info outside: $(call m.in/is_root_subdir,$(CWD)))' > $tmp

  run make OUTSIDE_FILE=$tmp -s -f ../Makefile
  echo "$output"

  [ $status -eq 0 ]

  expected="root: t
src: t
outside: "
  [ "$output" = "$expected" ]
}

@test "relative out-of-source mkdir outside of project's root" {
  run make -s -f ../Makefile mkdir-ko
  [ $status -ne 0 ]
}

@test "relative out-of-source mkdir inside of project's root" {
  make -s -f ../Makefile mkdir-ok
}

#
# out-of-source with absolute prefix path
#

@test "relative out-of-source is_subdir macro" {
  tmp=$(test_tmpfile .mk)
  echo '$(info outside: $(call m.in/is_root_subdir,$(CWD)))' > $tmp

  run make OUTSIDE_FILE=$tmp -s -f $BATS_TEST_DIRNAME/Makefile
  echo "$output"

  [ $status -eq 0 ]

  expected="root: t
src: t
outside: "
  [ "$output" = "$expected" ]
}

@test "relative out-of-source mkdir outside of project's root" {
  run make -s -f $BATS_TEST_DIRNAME/Makefile mkdir-ko
  [ $status -ne 0 ]
}

@test "relative out-of-source mkdir inside of project's root" {
  make -s -f $BATS_TEST_DIRNAME/Makefile mkdir-ok
}
