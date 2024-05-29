import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/kyc/simple_document_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SChooseDocument extends StatelessWidget {
  const SChooseDocument({
    super.key,
    this.active = false,
    required this.primaryText,
    required this.onTap,
  });

  final bool active;
  final String primaryText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          decoration: BoxDecoration(
            border: active
                ? null
                : Border.all(
                    color: SColorsLight().grey4,
                  ),
            color: active ? SColorsLight().grey5 : Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              const SDocumentIcon(),
              const SpaceW10(),
              Text(
                primaryText,
                style: sSubtitle2Style.copyWith(
                  color: active ? SColorsLight().blue : SColorsLight().black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
