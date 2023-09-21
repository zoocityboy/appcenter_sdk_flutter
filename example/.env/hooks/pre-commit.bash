#!/usr/bin/env bash

printf "\e[33;1m\n%s\n\e[0m\n" "🦊 pre-commit hook"

# Flutter formatter
printf "\e[33;1m%s\e[0m\n" '◦ [1/2] Running flutter formatter'
dart format . -l 120

hasNewFilesFormatted=$(git diff)
if [ -n "$hasNewFilesFormatted" ]; then
    git add .
    printf "\e[33;1m%s\e[0m\n" '  Formmated files added to git stage'
fi
printf "\e[32;1m%s\e[0m\n" '✓ flutter formater finished'
printf '%s\n' "${avar}"

# Flutter Analyzer
printf "\e[33;1m%s\e[0m\n" '◦ [2/2] Running flutter analyzer'
flutter analyze --no-pub --fatal-infos --fatal-warnings
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '✕ flutter analyzer failed'
  exit 1
fi
printf "\e[32;1m%s\e[0m\n" '✓ flutter analyzer finished'
printf '%s\n' "${avar}"