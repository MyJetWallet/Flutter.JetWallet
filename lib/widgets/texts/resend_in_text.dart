import 'package:auto_size_text/auto_size_text.dart';
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
      child: AutoSizeText(
        text,
        minFontSize: 4.0,
        textAlign: TextAlign.center,
        maxLines: 1,
        strutStyle: const StrutStyle(
          height: 1.5,
          fontSize: 12.0,
          fontFamily: 'Gilroy',
        ),
        style: TextStyle(
          height: 1.5,
          fontSize: 12.0,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
          color: colors.grey2,
        ),
      ),
    );
  }
}
