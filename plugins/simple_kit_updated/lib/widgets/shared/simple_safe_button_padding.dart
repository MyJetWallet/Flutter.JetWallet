import 'package:flutter/material.dart';

class SSafeButtonPadding extends StatelessWidget {
  const SSafeButtonPadding({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: (MediaQuery.of(context).padding.bottom <= 24 ? 8 : 0), //отступ шторки
      ),
      child: child,
    );
  }
}
