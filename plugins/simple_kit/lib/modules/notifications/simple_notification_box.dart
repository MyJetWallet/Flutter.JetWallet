import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SNotificationBox extends StatelessWidget {
  const SNotificationBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceH60(),
        Container(
          decoration: BoxDecoration(
            color: SColorsLight().red,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: SErrorIcon(
                  color: SColorsLight().white,
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 22,
                  ),
                  child: Text(
                    text,
                    maxLines: 10,
                    style: sBodyText1Style.copyWith(
                      color: SColorsLight().white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
