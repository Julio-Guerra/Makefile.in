load ../common

function prologue() {
  tmp=$1
  mkdir $tmp
  echo '$(info outside/0: $(CWD))'     > $tmp/Makefile.mk
  echo '$(eval $(call include, dir1))' >> $tmp/Makefile.mk
  mkdir $tmp/dir1
  echo '$(info outside/1: $(CBD))'     > $tmp/dir1/Makefile.mk
  echo '$(info outside/1: $(CWD))'     >> $tmp/dir1/Makefile.mk
}

function expected() {
  echo "0:./
1:./dir1/
2:./dir1/dir2/
3:./dir1/dir2/dir3/
2:./dir1/dir2/
1:./dir1/
4:$1/dir1/dir4/
1:./dir1/
outside/0: $2/
outside/1: ./dir1/
outside/1: $2/dir1/
1:./dir1/
0:./"
}

#
# in-source
#
@test "in-source directory tree" {
  tmp=$(test_tmpdir)
  prologue $tmp

  run make -s OUTSIDE_FILE=$tmp/Makefile.mk
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected . $tmp)" ]
}

#
# out-of-source with relative prefix path
#

@test "relative out-of-source directory tree" {
  tmp=$(test_tmpdir)
  prologue $tmp

  run make -s -f ../Makefile OUTSIDE_FILE=$tmp/Makefile.mk
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected .. $tmp)" ]
}

#
# out-of-source with absolute prefix path
#

@test "absolute out-of-source directory tree" {
  tmp=$(test_tmpdir)
  prologue $tmp

  run make -s -f $BATS_TEST_DIRNAME/Makefile OUTSIDE_FILE=$tmp/Makefile.mk
  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$(expected $BATS_TEST_DIRNAME $tmp)" ]
}
