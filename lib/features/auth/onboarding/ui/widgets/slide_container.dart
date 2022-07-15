import 'package:flutter/material.dart';

class SlideContainer extends StatelessWidget {
  const SlideContainer({
    Key? key,
    required this.color,
    required this.width,
  }) : super(key: key);

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
