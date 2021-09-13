import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    Key? key,
    this.appBar,
    this.bottomNavigationBar,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: child,
      ),
    );
  }
}
