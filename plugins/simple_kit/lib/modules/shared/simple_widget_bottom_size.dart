import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Widget that gets size of the child and returns it on the onChange callback
class SWidgetBottomSize extends StatefulWidget {
  const SWidgetBottomSize({
    Key? key,
    required this.child,
    required this.onChange,
  }) : super(key: key);

  final Widget child;
  final Function(Size?) onChange;

  @override
  State<SWidgetBottomSize> createState() => _SWidgetBottomSizeState();
}

class _SWidgetBottomSizeState extends State<SWidgetBottomSize> {
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
