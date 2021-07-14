import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
