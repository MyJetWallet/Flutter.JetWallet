import 'package:flutter/material.dart';

class FastCircularProgressIndicator extends StatefulWidget {
  const FastCircularProgressIndicator({
    this.speed = 2.0,
    this.strokeWidth = 4,
    this.color,
    super.key,
  });

  final double speed;
  final Color? color;
  final double strokeWidth;

  @override
  State<FastCircularProgressIndicator> createState() => _FastCircularProgressIndicatorState();
}

class _FastCircularProgressIndicatorState extends State<FastCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1000 / widget.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CircularProgressIndicator(
        color: widget.color,
        strokeWidth: widget.strokeWidth,
      ),
    );
  }
}
