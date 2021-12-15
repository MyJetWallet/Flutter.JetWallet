import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SContactItem extends StatelessWidget {
  const SContactItem({
    Key? key,
    this.onTap,
    required this.name,
    required this.phone,
  }) : super(key: key);

  final Function()? onTap;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 80.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SColorsLight().blue,
                  ),
                  child: Center(
                    child: Text(
                      initialsFrom(name),
                      style: sSubtitle3Style.copyWith(
                        color: SColorsLight().white,
                      ),
                    ),
                  ),
                ),
              ),
              const SpaceW20(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Baseline(
                    baseline: 38.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      name,
                      style: sSubtitle2Style,
                    ),
                  ),
                  Baseline(
                    baseline: 14.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      phone,
                      style: sBodyText2Style.copyWith(
                        color: SColorsLight().grey2,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
