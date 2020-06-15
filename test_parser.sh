rm -rf res.txt
for example in "examples"/*.cl
do
  printf '\n''\n'"======================" >> res.txt
  echo $example >> res.txt
  diff <(./flexer $example) <(./lexer $example) >> res.txt
done
