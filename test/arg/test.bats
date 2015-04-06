load ../common

@test "polymorphic macro" {
  run make -s
  [ $status -eq 0 ]
  expected="one
two
three
four
five
six
seven
eight
nine
ten"

  [ "$output" = "$expected" ]
}

@test "argv macro with no argument" {
  run make -s ko
  echo $output
  [ $status -ne 0 ]
}
