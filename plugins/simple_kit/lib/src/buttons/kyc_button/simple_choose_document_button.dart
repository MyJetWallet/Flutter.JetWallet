import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SChooseDocument extends StatelessWidget {
  const SChooseDocument({
    Key? key,
    this.activeDocument = false,
    required this.primaryText,
    required this.onTap,
  }) : super(key: key);

  final bool activeDocument;
  final String primaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        decoration: BoxDecoration(
          border: activeDocument ? null : Border.all(
            color: SColorsLight().grey4,
          ),
          color: activeDocument ? SColorsLight().grey5 : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            const SDocumentIcon(),
            const SpaceW10(),
            Text(
              primaryText,
              style: sSubtitle2Style.copyWith(
                color:
                    activeDocument ? SColorsLight().blue : SColorsLight().black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
