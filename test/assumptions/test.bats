load ../common

@test "operator += does't not expand the lvalue" {
  run make -s plusequal

  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "a b c" ]
}

@test "abspath does't not require to be prefixed" {
  run make -s abspath

  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "$BATS_TEST_DIRNAME/test" ]
}

@test "dir does't not require to be prefixed" {
  run make -s dir

  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "./" ]
}

@test "implicit argument forwarding" {
  run make -s arg-fwd

  echo "$output"
  [ $status -eq 0 ]
  [ "$output" = "test" ]
}
