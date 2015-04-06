load ../common

@test "stack macros" {
  run make -s

  echo "$output"
  [ $status -eq 0 ]
  expected=">a<
>b<
>c<
>g<
>a<
>b<
>c<
>d<
>e<
>foo<
>f<
>g<
><
>foooo<
>foo<
>foo<
><"

  [ "$output" = "$expected" ]
}
