import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_divider.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class CardOption extends StatelessWidget {
  const CardOption({
    Key? key,
    this.isSelected = false,
    this.hideDescription = false,
    this.isDisabled = false,
    required this.icon,
    required this.name,
    required this.onTap,
    this.description,
  }) : super(key: key);

  final bool isSelected;
  final bool hideDescription;
  final bool isDisabled;
  final Widget icon;
  final String name;
  final Function() onTap;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final mainColor = isSelected
        ? SColorsLight().blue
        : isDisabled
        ? SColorsLight().grey2
        : SColorsLight().black;

    final descriptionColor = isDisabled
        ? SColorsLight().grey2
        : SColorsLight().grey3;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: hideDescription ? 60 : 82,
          child: Column(
            children: [
              const SpaceH16(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SpaceH4(),
                      Stack(
                        children: [
                          icon,
                        ],
                      ),
                    ],
                  ),
                  const SpaceW12(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: sSubtitle1Style.copyWith(
                                  color: mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!hideDescription)
                          Text(
                            description!,
                            style: sBodyText2Style.copyWith(
                              color: descriptionColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpaceH16(),
            ],
          ),
        ),
      ),
    );
  }
}
