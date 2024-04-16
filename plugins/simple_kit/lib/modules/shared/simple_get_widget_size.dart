// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Widget that gets size of the child and returns it on the onChange callback
class SGetWidgetSize extends StatefulWidget {
  const SGetWidgetSize({
    super.key,
    required this.child,
    required this.onChange,
  });

  final Widget child;
  final Function(Size?) onChange;

  @override
  _SGetWidgetSizeState createState() => _SGetWidgetSizeState();
}

class _SGetWidgetSizeState extends State<SGetWidgetSize> {
  final widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return SizedBox(
      key: widgetKey,
      child: widget.child,
    );
  }
}
