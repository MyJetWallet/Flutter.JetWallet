import 'package:flutter/material.dart';

class AppVersionText extends StatelessWidget {
  const AppVersionText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'JetWallet app version 1.0.0: 1',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }
}
