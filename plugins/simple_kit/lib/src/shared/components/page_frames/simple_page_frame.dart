import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../stack_loader/view/stack_loader.dart';

class SPageFrame extends StatelessWidget {
  const SPageFrame({
    Key? key,
    this.header,
    this.loading,
    this.color = Colors.transparent,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;
  final StackLoaderNotifier? loading;

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
