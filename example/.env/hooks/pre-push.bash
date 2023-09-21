#!/usr/bin/env bash

printf "\e[33;1m\n%s\n\e[0m\n" "🦊 pre-push hook"

# Generate missing test imports for coverage
printf "\e[33;1m%s\e[0m\n" '◦ [1/2] Generate Code Coverage Imports'
dart test/helpers/code_coverage_helper.dart

# Unit tests
printf "\e[33;1m%s\e[0m\n" '◦ [2/2] Running unit tests'
flutter test --no-pub -r expanded
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '✕ flutter unit tests failed'
  exit 1
fi
printf "\e[32;1m%s\e[0m\n" '✓ finished running Unit Tests'
printf '%s\n' "${avar}"