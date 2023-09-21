import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/key_extension.dart';

mixin TrackableWidget on Widget, Diagnosticable {
  String get identity => toIdentityString();

  String toIdentityString() {
    final type = objectRuntimeType(this, 'Widget');

    return key == null ? type : '$type-${key?.toStringValue()}';
  }
}
