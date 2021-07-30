#!/bin/sh
set -e
cd "$(dirname "$0")"

cd tests

for test in *.c *.cpp; do
  #testname="${test%.*}"
  extension="${test##*.}"
  if [ "$extension" = cpp ]; then
    g++ -I.. "$test"
  else
    gcc -I.. "$test"
  fi
  ./a.out > check-stdout
  rm a.out
  if [ "$(cat check-stdout)" != "$(cat "$test.stdout")" ]; then
    echo "Failed: $test"
    echo "Got:"
    cat check-stdout
    rm check-stdout
    echo "Expected:"
    cat "$test.stdout"
    exit 1
  fi
done

rm -f check-stdout

echo "Done!"
