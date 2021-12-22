import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SPaymentSelectContactWithoutName extends StatelessWidget {
  const SPaymentSelectContactWithoutName({
    Key? key,
    required this.phone,
  }) : super(key: key);

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceW20(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                  ),
                  child: SPhoneIcon(
                    color: SColorsLight().black,
                  ),
                ),
                const SpaceW10(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Baseline(
                        baseline: 50.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          phone,
                          style: sSubtitle2Style,
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceW20(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
