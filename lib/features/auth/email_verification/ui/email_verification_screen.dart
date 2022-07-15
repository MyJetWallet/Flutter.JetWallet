import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EmailVerificationScreenBody();
  }
}

class _EmailVerificationScreenBody extends StatelessWidget {
  const _EmailVerificationScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      child: Container(
        child: Center(
          child: Text('EmailVerificationScreen'),
        ),
      ),
    );
  }
}
