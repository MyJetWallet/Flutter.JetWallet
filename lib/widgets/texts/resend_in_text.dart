import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ResendInText extends StatelessObserverWidget {
  const ResendInText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Center(
      child: Text(
        text,
        style: sCaptionTextStyle.copyWith(color: colors.grey2),
      ),
    );
  }
}
