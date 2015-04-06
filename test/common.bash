setup() {
  cd $BATS_TEST_DIRNAME
  setup_out_of_source
}

teardown() {
  cd $BATS_TEST_DIRNAME
  test_clean
}

function setup_out_of_source() {
  if [[ $BATS_TEST_DESCRIPTION =~ 'relative out-of-source' ]]; then
    bd=build
  elif [[ $BATS_TEST_DESCRIPTION =~ 'absolute out-of-source' ]]; then
    bd=$(test_tmpdir)
  fi

  if [[ "$bd" ]]; then
   mkdir -p $bd
   cd $bd
  fi
}

function test_tmpdir() {
  test_tmpfile
}

function test_tmpfile() {
  tmp=$(mktemp -u /tmp/test-$BATS_TEST_NAME-XXXXX$1)
  echo $tmp
}

function test_clean() {
  rm -rf /tmp/test-$BATS_TEST_NAME-*
  if [[ -d build ]]; then
    rm -rf build
  fi
}

function test_dir_layout() {
  find $1 -printf '%P\n' | sort
}

function test_diff_dir_layout {
  layout1="$(test_dir_layout $1)"
  layout2="$(test_dir_layout $2)"
  echo layout 1
  echo "$layout1"
  echo
  echo layout 2
  echo "$layout2"

  [[ "$layout1" = "$layout2" ]]
}
