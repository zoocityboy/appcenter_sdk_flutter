import 'package:flutter/material.dart';

class InteractionWidget {
  final Element element;
  final String description;
  final String type;
  final String eventType;

  const InteractionWidget({
    required this.element,
    required this.description,
    required this.type,
    required this.eventType,
  });
}
