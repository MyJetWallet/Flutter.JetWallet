import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../simple_paddings.dart';
import '../stack_loader/stack_loader.dart';

class SPageFrameWithPadding extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
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
