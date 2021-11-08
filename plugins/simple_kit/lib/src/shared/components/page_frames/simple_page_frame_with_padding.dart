import 'package:flutter/material.dart';

import '../simple_paddings.dart';

class SPageFrameWithPadding extends StatelessWidget {
  const SPageFrameWithPadding({
    Key? key,
    this.header,
    this.color = Colors.transparent,
    this.resizeToAvoidBottomInset = true,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;
  final Color color;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SPaddingH24(
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
