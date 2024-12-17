import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class NoActiveJarsPlaceholderWidget extends StatelessWidget {
  const NoActiveJarsPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40.0,
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Assets.svg.other.happySimpleSmall.simpleSvg(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Text(
            intl.jar_you_dont_have_any_open_jars,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: STStyles.subtitle2.copyWith(
              color: SColorsLight().gray8,
            ),
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
