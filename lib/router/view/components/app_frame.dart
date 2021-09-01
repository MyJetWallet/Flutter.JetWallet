import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
