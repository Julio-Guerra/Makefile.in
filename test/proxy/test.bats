load ../common

@test "transparent recipe proxy" {
  run make --no-print-directory proxyme-1 proxyme-2 proxyme-3
  [ $status -eq 0 ]

  expected="echo 'dummy transparent proxying ... proxyme-1'$
cat - <<EOF$
echo  hello$
echo  world$
echo proxyme-1$
EOF$
dummy transparent proxying ... proxyme-1$
echo  hello$
echo  world$
echo proxyme-1$
echo 'dummy transparent proxying ... proxyme-2'$
cat - <<EOF$
echo proxyme-2$
EOF$
dummy transparent proxying ... proxyme-2$
echo proxyme-2$
echo 'dummy transparent proxying ... proxyme-3'$
cat - <<EOF$
echo l1$
echo l2$
echo l3$
echo l4$
echo l5$
echo l6$
EOF$
dummy transparent proxying ... proxyme-3$
echo l1$
echo l2$
echo l3$
echo l4$
echo l5$
echo l6$"

  output=$(echo "$output" | cat -e)

  [ "$output" = "$expected" ]
}

@test "target proxy" {
  run make --no-print-directory m.in/term/color= proxy:proxyme-1 \
        proxy:proxyme-2 proxy:proxyme-3
  [ $status -eq 0 ]

  output=$(echo "$output" | cat -e)
  expected="[ proxy:proxyme-1 ]$
dummy proxying ...  make proxyme-1$
[ proxy:proxyme-2 ]$
dummy proxying ...  make proxyme-2$
[ proxy:proxyme-3 ]$
dummy proxying ...  make proxyme-3$"

  [ "$output" = "$expected" ]
}
