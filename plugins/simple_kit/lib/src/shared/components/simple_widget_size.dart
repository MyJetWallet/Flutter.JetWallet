import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Widget that gets size of the child and returns it on the onChange callback
class SWidgetSize extends StatefulWidget {
  const SWidgetSize({
    Key? key,
    required this.child,
    required this.onChange,
  }) : super(key: key);

  final Widget child;
  final Function(Size?) onChange;

  @override
  _SWidgetSizeState createState() => _SWidgetSizeState();
}

class _SWidgetSizeState extends State<SWidgetSize> {
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
    SchedulerBinding.instance!.addPostFrameCallback(postFrameCallback);

    return SizedBox(
      key: widgetKey,
      child: widget.child,
    );
  }
}
