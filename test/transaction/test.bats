load ../common

#
# in-source
#

@test "in-source build" {
  make FORMAT=ascii
  make FORMAT=ascii clean
  make FORMAT=ascii distclean
  make FORMAT=utf-8
  make FORMAT=utf-8 clean
  make FORMAT=utf-8 distclean

  run find -name ref -prune -type f -name '*.[oda]' -or -name '*.elf' \
      -or -name '*.map'
  [ "$status" -eq 0 ]
  [ "$output" = "" ]

}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source build" {
  make -f ../Makefile FORMAT=ascii
  make -f ../Makefile FORMAT=utf-8

  test_diff_dir_layout . ../ref

  make -f ../Makefile FORMAT=ascii distclean
  make -f ../Makefile FORMAT=utf-8 distclean

  run find -type f
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source build" {
  make -f $BATS_TEST_DIRNAME/Makefile FORMAT=ascii
  make -f $BATS_TEST_DIRNAME/Makefile FORMAT=utf-8

  test_diff_dir_layout . $BATS_TEST_DIRNAME/ref

  make -f $BATS_TEST_DIRNAME/Makefile FORMAT=ascii distclean
  make -f $BATS_TEST_DIRNAME/Makefile FORMAT=utf-8 distclean

  run find -type f
  [ "$status" -eq 0 ]
  [ "$output" = "" ]

}
