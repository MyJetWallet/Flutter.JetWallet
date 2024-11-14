import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';

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
                          activeColor: SColorsLight().grey5,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().grey2,
                          inactiveNameColor: SColorsLight().grey4,
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
                          inactiveColor: SColorsLight().grey4,
                          inactiveNameColor: SColorsLight().grey2,
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
