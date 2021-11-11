import 'dart:async';

import 'package:flutter/material.dart';

import 'components/loader_background.dart';
import 'components/loader_container.dart';

class StackLoader extends StatefulWidget {
  const StackLoader({
    Key? key,
    required this.child,
    required this.loading,
  }) : super(key: key);

  final Widget child;
  final bool loading;

  @override
  State<StackLoader> createState() => _StackLoaderState();
}

class _StackLoaderState extends State<StackLoader> {
  bool loading = false;
  Timer timer = Timer(const Duration(seconds: 0), () {});

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('=====================${widget.loading}');
    timer = Timer(const Duration(seconds: 1), () {
      if (widget.loading) {
        setState(() {
          loading = true;
        });
      }
    });

    return Stack(
      children: [
        widget.child,
        if (loading) ...[
          const LoaderBackground(),
          const LoaderContainer(),
        ]
      ],
    );
  }
}
