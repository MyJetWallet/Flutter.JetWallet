import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../simple_kit.dart';
import '../stack_loader/view/stack_loader.dart';

class SPageFrame extends ConsumerWidget {
  const SPageFrame({
    Key? key,
    this.header,
    this.loading,
    this.bottomNavigationBar,
    this.color = Colors.transparent,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;
  final StackLoaderNotifier? loading;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(sThemePod);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: bottomNavigationBar,
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
