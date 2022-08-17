import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

class ProgressBar extends StatefulHookWidget {
  const ProgressBar({
    Key? key,
    required this.time,
  }) : super(key: key);

  final int time;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SPaddingH24(
        child: LinearProgressIndicator(
          value: controller.value,
          semanticsLabel: 'Linear progress indicator',
        ),
      ),
    );
  }
}