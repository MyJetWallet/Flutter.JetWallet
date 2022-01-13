import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class KycSelfie extends StatelessWidget {
  const KycSelfie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('KycSelfie'),
        ],
      ),
    );
  }
}
