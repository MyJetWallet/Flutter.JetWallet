import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';

class ApplePaySelect extends StatelessWidget {
  const ApplePaySelect({
    super.key,
    this.onTap,
    required this.widgetSize,
    required this.limit,
  });

  final SWidgetSize widgetSize;
  final int limit;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width - 48;
    final width = currentWidth / 100 * limit;

    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey4,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      onTap: onTap,
      child: Container(
        height: widgetSize == SWidgetSize.small ? 64.0 : 88.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: colors.grey4,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 24.0,
          right: 24.0,
        ),
        child: Column(
          children: [
            // + 1 px border
            if (widgetSize == SWidgetSize.small) const SpaceH12(),
            // + 1 px border
            if (widgetSize == SWidgetSize.medium) const SpaceH23(),
            Row(
              children: [
                Image.asset(
                  applePayCardAsset,
                  width: 48,
                  height: 30.73,
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Column(
                    children: [
                      Baseline(
                        baseline: widgetSize == SWidgetSize.small ? 17.0 : 18.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Apple pay',
                                style: sSubtitle2Style.copyWith(
                                  color: limit == 100
                                      ? colors.grey2
                                      : colors.black,
                                ),
                              ),
                            ),
                            const SpaceW16(),
                          ],
                        ),
                      ),
                      Baseline(
                        baseline: 14.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                'description',
                                style: sCaptionTextStyle.copyWith(
                                  color: colors.grey3,
                                ),
                              ),
                            ),
                            const SpaceW16(),
                            Expanded(
                              child: Text(
                                'helper',
                                textAlign: TextAlign.end,
                                style: sCaptionTextStyle.copyWith(
                                  color: colors.grey3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceW19(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
