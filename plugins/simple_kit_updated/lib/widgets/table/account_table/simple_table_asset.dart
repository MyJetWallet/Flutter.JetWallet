import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/calculate_screen_size.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/round/round_button.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SimpleTableAsset extends StatelessWidget {
  const SimpleTableAsset({
    Key? key,
    this.onTableAssetTap,
    required this.isCard,
    this.assetIcon,
    this.needPadding = true,
    required this.label,
    this.supplement,
    this.hasLabelIcon = false,
    this.labelIcon,
    this.hasRightValue = true,
    this.rightValue,
    this.customRightWidget,
  }) : super(key: key);

  final VoidCallback? onTableAssetTap;

  final bool isCard;
  final Widget? assetIcon;

  final bool needPadding;

  final String label;
  final String? supplement;

  final bool hasRightValue;
  final String? rightValue;
  final Widget? customRightWidget;

  final bool hasLabelIcon;
  final Widget? labelIcon;

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTableAssetTap,
      child: SizedBox(
        height: needPadding ? 80 : 48,
        child: Padding(
          padding: needPadding
              ? const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                )
              : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!isCard) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: assetIcon ?? Assets.svg.medium.crypto.simpleSvg(),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Assets.svg.paymentMethodsCards.simple.defaultCard.simpleSvg(
                    width: 24,
                  ),
                ),
              ],
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*ConstrainedBox(
                            constraints: BoxConstraints(
                                 maxWidth: deviceSizeFrom(MediaQuery.of(context).size.height) == ScreenSizeEnum.small
                                  ? MediaQuery.of(context).size.width * .3
                                  : MediaQuery.of(context).size.width * .39,
                                
                                ),
                            child: Text(
                              label,
                              style: STStyles.subtitle1,
                            ),
                          ),
                          */
                          Expanded(
                            child: Text(
                              label,
                              style: STStyles.subtitle1,
                            ),
                          ),
                          const Gap(4),
                          Opacity(
                            opacity: hasLabelIcon ? 1 : 0,
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: labelIcon ??
                                  Assets.svg.medium.freeze.simpleSvg(
                                    color: SColorsLight().gray8,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (supplement != null)
                      Text(
                        supplement ?? '',
                        style: STStyles.body2Medium.copyWith(
                          color: SColorsLight().gray10,
                        ),
                      ),
                  ],
                ),
              ),
              if (hasRightValue) ...[
                //const Spacer(),
                Center(
                  child: customRightWidget ??
                      RoundButton(
                        value: rightValue ?? '',
                      ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
