import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showInvestCloseBottomSheet({
  required BuildContext context,
  required Function() onPrimaryButtonTap,
  required Function() onSecondaryButtonTap,
  required String primaryButtonName,
  required String secondaryButtonName,
  required bool isProfit,
  required Widget widget,
}) {
  showBasicBottomSheet(
    context: context,
    button: Material(
      color: SColorsLight().white,
      child: Observer(
        builder: (BuildContext context) {
          return SizedBox(
            height: 98.0,
            child: Column(
              children: [
                const SpaceH20(),
                SPaddingH24(
                  child: Row(
                    children: [
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().gray2,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().gray8,
                          inactiveNameColor: SColorsLight().gray4,
                          active: true,
                          name: primaryButtonName,
                          onTap: () {
                            onPrimaryButtonTap();
                          },
                        ),
                      ),
                      const SpaceW10(),
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().black,
                          activeNameColor: isProfit ? SColorsLight().green : SColorsLight().red,
                          inactiveColor: SColorsLight().gray4,
                          inactiveNameColor: SColorsLight().gray8,
                          active: true,
                          name: secondaryButtonName,
                          onTap: () {
                            onSecondaryButtonTap.call();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceH34(),
              ],
            ),
          );
        },
      ),
    ),
    children: [widget],
  );
}
