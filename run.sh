#!/bin/sh

dart run pigeon \
  --input pigeons/appcenter.dart

dart run pigeon \
  --input pigeons/analytics.dart
dart run pigeon \
  --input pigeons/distribute.dart
dart run pigeon \
  --input pigeons/crashes.dart
# dart run pigeon \
#   --input pigeons/messages.dart