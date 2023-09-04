import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class DepositInfoTag extends StatelessObserverWidget {
  const DepositInfoTag({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      width: double.infinity,
      color: colors.redLight,
      height: 68.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70.0,
          ),
          child: Text(
            text,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: sBodyText2Style.copyWith(
              color: colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
