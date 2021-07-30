#!/bin/sh
set -e
cd "$(dirname "$0")"

cd tests

for test in *.c; do
  testname="${test%.*}"
  gcc -I.. "$test"
  ./a.out > check-stdout
  rm a.out
  if [ "$(cat check-stdout)" != "$(cat "$testname.stdout")" ]; then
    echo "Failed: $testname"
    echo "Expected:"
    cat "$testname.stdout"
    echo "Got:"
    cat check-stdout
    rm check-stdout
    exit 1
  fi
done

rm -f check-stdout

echo "Done!"
