load ../common

@test "list macros" {
  run make -s

  echo "$output"
  [ $status -eq 0 ]
  expected="mylist=1 2 3 t1_1 t1_2 4 5 t1_3 t1_4 t2_1
mylist/value=1 2 3 t1_1 t1_2 4 5 t1_3 t1_4 t2_1 \$(test)
mylist/t1=t1_1 t1_2 t1_3 t1_4
mylist/t1=t1_1 t1_2 t1_3 t1_4 ok
mylist/t2=t2_1
flushed: "
  [ "$output" = "$expected" ]
}
