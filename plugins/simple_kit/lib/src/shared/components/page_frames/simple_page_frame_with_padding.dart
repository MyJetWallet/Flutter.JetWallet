import 'package:flutter/material.dart';

import '../simple_paddings.dart';

class SPageFrameWithPadding extends StatelessWidget {
  const SPageFrameWithPadding({
    Key? key,
    this.header,
    required this.child,
  }) : super(key: key);

  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SPaddingH24(
        child: Column(
          children: [
            if (header != null) header!,
            child,
          ],
        ),
      ),
    );
  }
}
