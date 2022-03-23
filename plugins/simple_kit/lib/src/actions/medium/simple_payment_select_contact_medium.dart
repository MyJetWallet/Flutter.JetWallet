import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SPaymentSelectContactMedium extends StatelessWidget {
  const SPaymentSelectContactMedium({
    Key? key,
    required this.name,
    required this.phone,
  }) : super(key: key);

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Container(
        height: 88.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: SColorsLight().grey4,
          ),
        ),
        child: Column(
          children: [
            const SpaceH23(), // + 1px border
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceW19(), // + 1px border
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SColorsLight().blue,
                  ),
                  child: Center(
                    child: Baseline(
                      baseline: 16.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        initialsFrom(name),
                        style: sSubtitle3Style.copyWith(
                          color: SColorsLight().white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SpaceW10(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Baseline(
                        baseline: 18.0,
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
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceW19(), // + 1px border
              ],
            ),
          ],
        ),
      ),
    );
  }
}
