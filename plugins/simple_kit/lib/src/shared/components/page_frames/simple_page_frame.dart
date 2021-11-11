import 'package:flutter/material.dart';
import 'package:simple_kit/src/shared/components/page_frames/components/stack_loader.dart';

class SPageFrame extends StatelessWidget {
  const SPageFrame({
    Key? key,
    this.header,
    this.color = Colors.transparent,
    //TODO (Vova): change to required
    this.loading = false,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackLoader(
        loading: loading,
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: Material(
                color: color,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
