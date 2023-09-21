import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'trackable_widget.dart';

class CardButton extends StatelessWidget
    with DiagnosticableTreeMixin, TrackableWidget {
  const CardButton({required this.onPressed, required this.child, super.key});
  final void Function(String identity) onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      elevation: 0,
      child: Builder(
        builder: (context) {
          return InkWell(
            onTap: () => onPressed.call(identity),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}
