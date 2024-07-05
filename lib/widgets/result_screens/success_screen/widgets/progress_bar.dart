import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ProgressBar extends StatefulObserverWidget {
  const ProgressBar({
    super.key,
    required this.time,
    required this.colors,
  });

  final int time;
  final SimpleColors colors;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
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
      body: LinearProgressIndicator(
        value: controller.value,
        backgroundColor: widget.colors.grey4,
        valueColor: AlwaysStoppedAnimation<Color>(widget.colors.black),
      ),
    );
  }
}
