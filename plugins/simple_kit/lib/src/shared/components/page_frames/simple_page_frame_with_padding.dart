import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../simple_kit.dart';
import '../stack_loader/view/stack_loader.dart';

class SPageFrameWithPadding extends ConsumerWidget {
  const SPageFrameWithPadding({
    Key? key,
    this.header,
    this.loading,
    this.color = Colors.transparent,
    this.resizeToAvoidBottomInset = true,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;
  final bool resizeToAvoidBottomInset;
  final StackLoaderNotifier? loading;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(sThemePod);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: StackLoader(
        loading: loading,
        child: SPaddingH24(
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
      ),
    );
  }
}
